<script setup>
import {computed, ref, useTemplateRef, watch, watchEffect} from "vue";
import {useAuth} from "@/composables/auth.js";
import {config} from "@/config.js";
import {formatPrice} from "@/utils/format.js";

// future improvement might be to inject cart obj with state and functions to manipulate cart contents. build at app level,
// and determine possible storage/caching mechanism. parent can manipulate state via exposed fxns, and this component
// becomes more of a dumb display mechanism. For now, exposing internals of this to parent, for expediency.
const {restaurant} = defineProps({
  restaurant: {
    type: Object,
    required: true,
  },
})

const apiUrl = `${config.get(config.API_BASE_URL)}/customers/orders`;

const items = ref({});
const placed = ref(false);
const {signedIn, headerVal} = useAuth();

const addItem = (meal, quantity) => {
  items.value[meal.id] ||= {meal, quantity: 0};
  items.value[meal.id].quantity += quantity;
}

// null quantity is removal of all of item
const removeItem = (mealId, quantity = null) => {
  const item = items.value[mealId];

  if (item == null) return;

  if (quantity == null) {
    delete items.value[mealId];
    return;
  }

  item.quantity -= quantity;

  if (item.quantity <= 0) {
    delete items.value[mealId];
    return;
  }
}

const itemCounts = computed(() => Object.entries(items.value).reduce((acc, [menuId, item]) => {
  acc[menuId] = item.quantity;
  return acc;
}, {}));

const totalPriceFormatted = computed(() => {
  const total = Object.values(items.value).reduce((acc, curr) => {
    return acc += (curr.meal.price_in_cents * curr.quantity);
  }, 0);
  return formatPrice(total);
});

// TODO currently a mismatch b/w server mechanism for handling of quantities (via duplicated join rows) and handling in
// frontend (via explicit quantities in items map), so convert them here.
// Takes shape of {mealid: {meal, quantity}} and makes [mealid, mealId,...], repeating meal ids for quantities > 1.
const convertItemsForPost = (itemsMapVal) => {
  return Object.values(itemsMapVal).reduce((acc, curr) => {
    for(let i = 0; i < curr.quantity; i++) {
      acc.push(curr.meal.id);
    }
    return acc;
  }, []);
}

// TODO all auth'd api calls should react to 401, invalidate session storage and redirect to signin
const saveOrder = async () => {
  placed.value = true;

  const resp = await fetch(apiUrl, {
    method: 'POST',
    headers: {
      "Authorization": headerVal.value,
      'Content-Type': 'application/json'
    },

    body: JSON.stringify({
      restaurant_id: restaurant.id,
      meal_ids: convertItemsForPost(items.value)
    })
  });

  const respJson = await resp.json();
  console.log(respJson);
}

// allow ref pointing to this component in parent to enable access to some of this component's attributes/fxns
defineExpose({
  addItem,
  removeItem,
  itemCounts
})

</script>

<template>
  <div class="col-md-6"></div>
  <div class="col-md-6 text-right">
    <div class="row">
      <div class="col">
        <h2 class="pt-4 cart-header">{{ restaurant.name }} Cart</h2>
      </div>
    </div>

    <!--  loops values in default syntax -->
    <div v-for="item in items" class="row pb-3">
      <div class="col">
        <div class="row">
          <div class="col">
            {{ item.meal.name }} - {{ formatPrice(item.meal.price_in_cents) }}
          </div>
        </div>
        <div>
          <div>
            Quantity: {{ item.quantity }}
          </div>
        </div>
        <div>
          <button @click="removeItem(item.meal.id)" >Remove</button>
        </div>
      </div>
    </div>

    <div class="row ">
      <div class="col-md-6"></div>
      <div class="col-md-6">
        <div class="font-weight-bold">
          TOTAL: {{ totalPriceFormatted }}
        </div>
        <div class="pt-2 pb-5">
          <button @click="saveOrder" :disabled="placed || !signedIn">Place Order</button>
          <!-- TODO route to order status/history   -->
          <div v-if="placed">Order placed!</div>
          <div v-if="!signedIn">Please sign in to Order</div>
        </div>
      </div>
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
