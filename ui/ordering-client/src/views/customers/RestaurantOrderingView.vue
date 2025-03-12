<script setup>
import {ref, useTemplateRef, watch, watchEffect} from "vue";
import {useRoute} from "vue-router";
import Cart from "@/components/Cart.vue";
import {config} from "@/config.js";
import {formatPrice} from "@/utils/format.js";
import imgUrl from "@/assets/restaurant.png";

const route = useRoute();
const restaurant = ref(null);
const cartRef = useTemplateRef('cart');

watchEffect(async () => {
  const apiUrl = `${config.get(config.API_BASE_URL)}/restaurants`
  const resp = await fetch(`${apiUrl}/${route.params.id}`);
  const respJson = await resp.json();

  console.log(respJson);
  restaurant.value = respJson;
});

</script>

<template>
  <main v-if="restaurant" class="col-12">
    <div>
      <div>
        <div class="row">
          <h1 class="pt-4">Browse {{ restaurant.name }}</h1>
        </div>
      </div>
      <div v-for="meal in restaurant.meals" class="row pt-4">

        <div class="card col-12">
          <div class="row no-gutters">
            <div class="col-md-2">
              <div class="fake-meal-image pt-3">TASTY IMAGE</div>
            </div>


            <div class="col-md-10">
              <div class="card-body row">

                <div class="col-7">
                  <h2 class="card-title card-name">{{ meal.name }}</h2>
                  <div class="card-text"> {{ meal.description }} </div>
                  <div class="price">{{ formatPrice(meal.price_in_cents) }}</div>


                </div>
                <div class="col-5 text-right m-auto">
                    <div class="pl-1 pr-1 d-inline">
                      <button :disabled="!cartRef || !cartRef.itemCounts[meal.id] || cartRef.itemCounts[meal.id] <= 0"
                              @click="cartRef.removeItem(meal.id, 1)">
                        -
                      </button>
                    </div>
                    <div class="pl-1 pr-1 d-inline">
                      <button  @click="cartRef.addItem(meal, 1)">
                        +
                      </button>
                    </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <!--      prop/variable assignment, so a short-hand 'bind' here-->
        <Cart :restaurant="restaurant" ref="cart" />
      </div>
    </div>
  </main>
</template>
