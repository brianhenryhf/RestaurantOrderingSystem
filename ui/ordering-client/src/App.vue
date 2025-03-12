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
      <RouterLink class="pl-3" to="/auth/sign_in">Sign In / Up</RouterLink>

      <!-- TODO vary links shown based on user type -->
    </nav>
  </header>
  <RouterView />
</template>

<!-- style scoped>
header {
  line-height: 1.5;
  max-height: 100vh;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

nav {
  width: 100%;
  font-size: 12px;
  text-align: center;
  margin-top: 2rem;
}

nav a.router-link-exact-active {
  color: var(--color-text);
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
}

nav a:first-of-type {
  border: 0;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
}
</style-->
