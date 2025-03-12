import { createRouter, createWebHistory } from 'vue-router'
import RestaurantsView  from "@/views/RestaurantsView.vue";
import AuthView from "@/views/AuthView.vue";
import RestaurantOrderingView from "@/views/customers/RestaurantOrderingView.vue";
import OrderView from "@/views/customers/OrderView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'restaurants',
      component: RestaurantsView,
    },
    { //TODO make this home, though redirect past it if auth'd to customer/user homes
      path: '/auth/:fxn',
      name: 'auth',
      component: AuthView,
    },
    // customer paths - keep them looking generic, simpler
    {
      path: '/restaurants/:id/place-order',
      name: 'place-order',
      component: RestaurantOrderingView,
    },
    // {
    //   path: '/orders',
    //   name: 'orders',
    //   component: ListOrdersView,
    // },
    {
      path: '/order/:id',
      name: 'order',
      component: OrderView,
    },
  ],
})

export default router
