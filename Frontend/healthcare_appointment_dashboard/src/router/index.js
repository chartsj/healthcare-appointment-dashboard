import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import PredictRiskView from '../views/PredictRiskView.vue'
import UpcomingAppointmentsView from '../views/UpcomingAppointmentsView.vue'
import UpcomingPredictionResultsView from '../views/UpcomingPredictionResultsView.vue'
import AppointmentRecordsView from '../views/AppointmentRecordsView.vue'
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
  {
    path:'/appointments',
    name:'appointments',
    component:UpcomingAppointmentsView
  },
  {
  path: '/prediction-results',
  name: 'PredictionResults',
  component: UpcomingPredictionResultsView
  },
  {
    path:'/appointment-records',
    name:'AppointmentRecords',
    component: AppointmentRecordsView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router