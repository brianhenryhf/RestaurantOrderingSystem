<script setup>
import {computed, ref, watch} from "vue";
import {useRoute, useRouter} from "vue-router";
import {useAuth} from "@/composables/auth.js";
import {config} from "@/config.js";


const route = useRoute();
const router = useRouter();
const {storeHeaderVal, signedIn} = useAuth();

const email = ref(null);
const password = ref(null);

// expect sign_in or sign_up
let authFxn = route.params.fxn ?? 'sign_in';

const apiUrl = computed(() => {
  let pathSuffix = null;

  if (authFxn === 'sign_up') pathSuffix = '';
  else pathSuffix = `/${authFxn}`;
  return `${config.get(config.API_BASE_URL)}/users${pathSuffix}`;
});

watch(
    // component is reused for all paths that match, so re-set new data
    () => route.params.fxn,
    (newFxn, oldFxn) => {
      authFxn = newFxn;
    }
)

// TODO refactor all api calls to api service module.
const sendAuth = async () => {
  const resp = await fetch(apiUrl.value, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },

    body: JSON.stringify({
      user: {
        email: email.value,
        password: password.value
      }
    })
  });

  // whole header value is usable in requests - no need to split out Bearer vs JWT.
  storeHeaderVal(resp.headers.get("Authorization"));

  const respJson = await resp.json();
  console.log(respJson);

  // TODO message - confirmation message, and or indicator in nav that already logged in.
  // TODO route user based on type, to different next page?
  await router.push({name: 'restaurants'})

}

</script>

<template>
  <main>
    <div class="layout">
      <div class="header">
        <div class="mui-container">
          <br>
          <template v-if="authFxn === 'sign_up'" >
            <div class="title">Sign Up</div>
            <RouterLink :to="{ name: 'auth', params: { fxn: 'sign_in' } }" >(Sign In instead)</RouterLink>
          </template>
          <template v-else >
            <div class="title">Sign In {{ signedIn ? '(again)' : '' }}</div>
            <RouterLink :to="{ name: 'auth', params: { fxn: 'sign_up' } }" >(Sign Up instead)</RouterLink>
          </template>
        </div>
      </div>
      <form @submit.prevent="sendAuth">
        <input type="email" v-model="email" placeholder="Email">
        <input type="password" v-model="password" placeholder="Password">
        <button type="submit">Submit</button>
      </form>
    </div>
  </main>
</template>