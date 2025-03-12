<script setup>
import {ref, watch} from "vue";
import {config} from "@/config.js";
import {useAuth} from "@/composables/auth.js";

import imgUrl from '../assets/restaurant.png';

const {signedIn} = useAuth();

const restaurants = ref([]);

watch(() => {}, async () => {
  const apiUrl = `${config.get(config.API_BASE_URL)}/restaurants`
  const resp = await fetch(apiUrl);
  const respJson = await resp.json();

  console.log(respJson);
  restaurants.value = respJson;
},{immediate: true})

</script>

<template>
  <main class="col-12">
    <div class="row">
      <h1 class="pt-4">Browse Restaurants</h1>
    </div>
    <div v-for="restaurant in restaurants" class="row pt-4">
      <div class="card col-12">
        <div class="row no-gutters">
          <div class="col-md-2">
            <img :src="imgUrl" class="restaurant-image" />
          </div>
          <div class="col-md-10">
            <div class="card-body row">
              <div class="col-7">
                <h2 class="card-title card-name">{{restaurant.name }}</h2>
                <div class="card-text"> {{ restaurant.description }} </div>
              </div>
              <div class="col-5 text-right m-auto">
                <RouterLink class="card-link" :to="{name: 'place-order', params: {id: restaurant.id}}">{{ signedIn ? 'Order' : 'View Menu'}}</RouterLink>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  </main>
</template>