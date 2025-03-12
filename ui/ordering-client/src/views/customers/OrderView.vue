<script setup>
import {computed, ref, useTemplateRef, watch, watchEffect} from "vue";
import {useAuth} from "@/composables/auth.js";
import {config} from "@/config.js";
import {formatPrice, formatTimestamp} from "@/utils/format.js";
import {useRoute, useRouter} from "vue-router";


// owner would be similar/same. differnt path with restaurant id. move the below out to a parameterizable component perhaps
// (pass in api url)

// will need: (for statuses)
// x POST /customers/orders/:order_id/order_statuses
// POST /owners/restaurants/:restaurant_id/orders/:order_id/order_statuses  #this really could perhaps be aliased to something shallower


// x /customers/orders/:id
// /owners/restaurants/:restaurant_id/orders/:id

// data needed:
// restaurant name


const route = useRoute();
const {signedIn, headerVal} = useAuth();

const order = ref(null);
const nextStatus = ref(null);

// alternate longhand of watchEffect basically - need to be watching changes to route.params.id, and the magic function
/// this watches does that.
// watch(() => route.params.id, async () => {
//   const apiUrl = `${config.get(config.API_BASE_URL)}/customers/orders/${route.params.id}`
//   const resp = await fetch(apiUrl, {
//     headers: {"Authorization": headerVal.value}
//   });
//
//   const respJson = await resp.json();
//
//   console.log(respJson);
//   order.value = respJson;
// },{immediate: true})

const loadOrder = async () => {
  const apiUrl = `${config.get(config.API_BASE_URL)}/customers/orders/${route.params.id}`
  const resp = await fetch(apiUrl, {
    headers: {"Authorization": headerVal.value}
  });

  const respJson = await resp.json();

  console.log(respJson);
  order.value = respJson;
}

watchEffect(loadOrder);


// manual entry of status is for demo purposes only.
// TODO ideally order/order_status api would present (next) available_statuses for user type, and we can display
// choice, or disable button if no choices.
const updateStatus = async () => {
  const apiUrl = `${config.get(config.API_BASE_URL)}/customers/orders/${route.params.id}/order_statuses`
  const resp = await fetch(apiUrl, {
    method: 'POST',
    headers: {
      "Authorization": headerVal.value,
      'Content-Type': 'application/json'
    },

    body: JSON.stringify({
      "status": nextStatus.value
    })
  });

  const respJson = await resp.json();
  console.log(respJson);

  //force reload of whole order to get new status - heavy handed, but fast impl.
  await loadOrder();
}

</script>

<template>
  <div v-if="order" class="layout">
    <div class="header">
      <div class="mui-container">
        <br>
        <!-- TODO update order payloads to return user email ordering, restaurant name/id, and display here -->
        <div class="title"> Order</div>
        <div class="title">Date: {{ formatTimestamp(order.order_date) }}</div>
      </div>

    </div>

    <div v-for="meal in order.meals" class="content">
      <div class="mui-container">
        <div class="mui-row">
          <div class="mui-panel">
            <div class="card">
              <div class="card-details">
                <div>
                  {{ meal.name }}
                </div>
              </div>
              <div class="card-trailing">
                <div class="price"> {{ formatPrice(meal.price_in_cents) }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div>
      TOTAL: {{ formatPrice(order.total_in_cents) }}
    </div>
    <div>
      <div>
        Current Status:
        <span style="text-transform: uppercase">{{ order.current_status.status }}</span>
        as of {{ formatTimestamp(order.current_status.updated_at) }}
      </div>
      <button @click="updateStatus">Update Status</button>
      <input v-model="nextStatus" placeholder="New Status">
    </div>

  </div>
</template>

<!--<style scoped>-->
<!--h1 {-->
<!--  font-weight: 500;-->
<!--  font-size: 2.6rem;-->
<!--  position: relative;-->
<!--  top: -10px;-->
<!--}-->

<!--h3 {-->
<!--  font-size: 1.2rem;-->
<!--}-->

<!--.greetings h1,-->
<!--.greetings h3 {-->
<!--  text-align: center;-->
<!--}-->

<!--@media (min-width: 1024px) {-->
<!--  .greetings h1,-->
<!--  .greetings h3 {-->
<!--    text-align: left;-->
<!--  }-->
<!--}-->
<!--</style>-->
