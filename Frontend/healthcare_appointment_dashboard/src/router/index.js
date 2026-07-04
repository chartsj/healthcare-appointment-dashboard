import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import PredictRiskView from '../views/PredictRiskView.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView,
  },
  {
    path: '/predict',
    name: 'predict',
    component: PredictRiskView,
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router