<script setup>
import { RouterLink, RouterView } from 'vue-router'
import {useAuth} from "@/composables/auth.js";

const {signedIn} = useAuth();
</script>

<template>
  <header class="row justify-content-between pt-3 pb-3" style="background-color: blanchedalmond" >
    <div class="col-4">
      <span class="font-weight-bold app-fake-logo" to="/">🍔 Ordering System</span>
    </div>
    <nav class="col-md-8 text-right m-auto">
      <RouterLink class="pl-3" to="/">Home</RouterLink>
      <template v-if="signedIn">
        <!-- hardcode while no list orders view.. edit url bar as needed -->
        <RouterLink class="pl-3" to="/order/39">View Order</RouterLink>
        <RouterLink class="pl-3"  to="/order/36">View Other Order</RouterLink>
      </template>
      <template v-else>
        <RouterLink class="pl-3" to="/auth/sign_in">Sign In / Up</RouterLink>
      </template>
      <!-- TODO vary links shown based on user type -->
    </nav>
  </header>
  <RouterView />
</template>

