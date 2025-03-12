// whole header value is usable in requests - no need to split out Bearer vs JWT.
import {computed, ref} from "vue";

const authHeaderVal = ref(null);

// Re-set authHeaderVal state the first time this module is imported (after page refresh, for example).
(function () {
  if(sessionStorage.getItem('authHeaderVal') != null && authHeaderVal.value == null) {
    authHeaderVal.value =  sessionStorage.getItem('authHeaderVal')
  }
})();


const storeHeaderVal = (val) => {
  //use ref for reactivity, and session storage to guard against browser refresh losing ephemeral data
  // Computed fxns will be run again when browser refreshes.
  authHeaderVal.value = val;
  sessionStorage.setItem('authHeaderVal', val);
};

const headerVal = computed(() => {
  return authHeaderVal.value;
});

// TODO improvement:
//    a) a mechanism to ping for validity every x minutes, or
//    b) read jwt for expiration and check this periodically to warn user and invalidate token.
const signedIn = computed(() => {
  return (authHeaderVal.value != null);
});

export function useAuth() {
  return {
    storeHeaderVal,
    headerVal,
    signedIn
  }
}