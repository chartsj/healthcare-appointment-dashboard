<template>
    <main class="min-h-screen bg-slate-50 px-6 py-6">
        <div class="mb-6">
            <RouterLink
            to="/"
            class="mb-6 text-sm font-medium text-blue-600 hover:underline"
            >
            ← Back to Home
            </RouterLink>
        </div>
        <header class="mb-6">
            <h1 class="text-3xl font-bold text-slate-900">No-Show Risk Prediction</h1>
            <p class="mt-2 text-slate-600">
                Generate no-show risk scores for appointments scheduled in the next 7 days.
            </p>
        </header>
        <section class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
            <header class="mb-5">
                <h2 class="text-xl font-semibold text-slate-900">Upcoming Appointment to Analyse</h2>
                <p class="mt-1 text-sm text-slate-500">These are appointments scheduled within the next 7 days. Predictions will be generated for the appointments shown below.</p>
            </header>
            <div class="overflow-x-auto">
            <table class="w-full border-collapse text-left text-sm">
                <thead class="bg-slate-100 text-slate-700">
                <tr>
                    <th class="px-4 py-3 font-semibold">Appointment ID</th>
                    <th class="px-4 py-3 font-semibold">Patient ID</th>
                    <th class="px-4 py-3 font-semibold">Appointment Date</th>
                    <th class="px-4 py-3 font-semibold">Appointment Time</th>
                    <th class="px-4 py-3 font-semibold">Department</th>
                    <th class="px-4 py-3 font-semibold">Type</th>
                    <th class="px-4 py-3 font-semibold">Status</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <tr class="hover:bg-slate-50" v-for="appointment in upcomingAppointments" :key="appointment.appointment_id in appointment">
                        <td class="px-4 py-3 ">{{ appointment.appointment_id }}</td>
                        <td class="px-4 py-3">{{  appointment.patient_id}}</td>
                        <td class="px-4 py-3">{{  appointment.appointment_date}}</td>
                        <td class="px-4 py-3">{{  appointment.appointment_time}}</td>
                        <td class="px-4 py-3">{{  appointment.department_name}}</td>
                        <td class="px-4 py-3">{{  appointment.appointment_type}}</td>
                        <td class="px-4 py-3">{{  appointment.appointment_status}}</td>
                    </tr>
                </tbody>
            </table>
            </div>

            <p class="mt-4 rounded-lg bg-slate-50 px-4 py-3 text-sm text-slate-500"
             v-if="upcomingAppointments.length===0">
                No upcoming appointments found in the next 7 days.
            </p>
        </section>
        <section class="mt-6 rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
            <header class="mb-5">
                <h2 class="text-xl font-semibold text-slate-900">Run Predictions</h2>
                <p class="mt-1 text-sm text-slate-500">Generate no-show risk scores for the upcoming appointments listed above.</p>
            </header>
            <button
                type="button"
                @click="runPredictions"
                :disabled="isRunning || upcomingAppointments.length === 0"
                class="rounded-lg bg-blue-600 px-5 py-2 font-medium text-white hover:bg-blue-700 cursor-pointer disabled:cursor-not-allowed disabled:bg-slate-300 disabled:text-slate-500"
                >
                {{ isRunning ? 'Running Predictions...' : 'Run Predictions' }}
            </button>
            <p v-if="successMessage" class="mt-5 rounded-lg border border-green-200 bg-green-50 px-4 py-3 text-sm font-medium text-green-700">
                {{ successMessage }}
            </p>
            <div v-if="summary"  class="mt-5 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                    <p class="text-sm font-medium text-slate-500">Total Appointments</p>
                    <p class="mt-2 text-2xl font-bold text-slate-900">
                    {{ summary['total_appointments'] }}
                    </p>
                </div>
                
                <div class="rounded-xl border border-red-200 bg-red-50 p-4">
                    <p class="text-sm font-medium text-red-600">High Risk</p>
                    <p class="mt-2 text-2xl font-bold text-red-700">
                    {{ summary['high_risk'] }}
                    </p>
                </div>

                <div class="rounded-xl border border-yellow-200 bg-yellow-50 p-4">
                    <p class="text-sm font-medium text-yellow-700">Medium Risk</p>
                    <p class="mt-2 text-2xl font-bold text-yellow-800">
                        {{ summary['medium_risk'] }}
                    </p>
                </div>

                <div class="rounded-xl border border-green-200 bg-green-50 p-4">
                    <p class="text-sm font-medium text-green-700">Low Risk</p>
                    <p class="mt-2 text-2xl font-bold text-green-800">
                        {{ summary['low_risk'] }}
                    </p>
                </div>
                
               
            </div>
            <div v-if="predictions.length>0"  class="mt-8 rounded-xl border border-slate-200 bg-white shadow-sm">
                <div class="border-b border-slate-200 px-5 py-4">
                    <h3 class="text-lg font-semibold text-slate-900">
                    Prediction Results
                    </h3>
                    <p class="mt-1 text-sm text-slate-500">
                    Detailed no-show risk predictions for upcoming appointments.
                    </p>
                </div>
                <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-slate-200">
                        <thead class="bg-slate-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">
                                    Appointment ID
                                </th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">
                                    Patient ID
                                </th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">
                                    Appointment Date
                                </th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">
                                    Appointment Time
                                </th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">
                                    No Show Probability
                                </th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">
                                    Risk Level
                                </th>
                                <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">
                                    Predicted At
                                </th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200 bg-white">
                            <tr
                            v-for="prediction in predictions"
                            :key="prediction.appointment_id"
                            class="hover:bg-slate-50"
                            >
                                <td class="px-4 py-3 text-sm text-slate-900">
                                    {{ prediction.appointment_id }}
                                </td>
                                <td class="px-4 py-3 text-sm text-slate-900">
                                    {{ prediction.patient_id }}
                                </td>
                                <td class="px-4 py-3 text-sm text-slate-900">
                                    {{ prediction.appointment_date }}
                                </td>
                                <td class="px-4 py-3 text-sm text-slate-900">
                                    {{ prediction.appointment_time }}
                                </td>
                                <td class="px-4 py-3 text-sm text-slate-900">
                                    {{ prediction.no_show_probability }}
                                </td>
                                <td class="px-4 py-3 text-sm">
                                    <span
                                    class="rounded-full px-3 py-1 text-xs font-semibold"
                                    :class="{
                                        'bg-red-100 text-red-700': prediction.risk_level === 'High',
                                        'bg-yellow-100 text-yellow-800': prediction.risk_level === 'Medium',
                                        'bg-green-100 text-green-700': prediction.risk_level === 'Low'
                                    }"
                                    >
                                    {{ prediction.risk_level }}
                                    </span>
                                </td>
                                <td class="px-4 py-3 text-sm text-slate-500">
                                    {{ prediction.predicted_at }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
        
    
  </main>
</template>
<script setup>
import {ref,onMounted} from 'vue'
const loading = ref(true)
const error = ref(null)

const upcomingAppointments=ref([])
const isRunning=ref(false)
const days=7
const summary =ref(null)
const successMessage=ref('')

const predictions=ref([])
const errorMessage=ref('')
onMounted(async ()=>{
    try{
        const response = await fetch(
            `http://localhost:8000/appointments/upcoming?days=${days}`)
        
        
        const results = await response.json()
        upcomingAppointments.value=results
        
    }
    catch (err){
        error.value=err
    }
    finally{
        loading.value=false
    }
})

const fetchPredictionResults = async () => {
  const response = await fetch(
    `http://localhost:8000/no-show-predictions/upcoming?days=${days}`
  )

  const results = await response.json()
  

  if (!response.ok) {
    throw new Error(results.detail || "Failed to fetch prediction results.")
  }

  predictions.value = results['predictions']
  console.log("predictions.value: ", predictions.value)
}


const runPredictions = async()=>{

    try {
        isRunning.value=true
        const response=await fetch(`http://localhost:8000/no-show-predictions/run?days=${days}`)
        const results = await response.json()
        successMessage.value=results["message"]
        summary.value = results["summary"]

        await fetchPredictionResults()
    }
    catch (error) {
        console.error(error)
        errorMessage.value = 'Failed to generate predictions.'
    } finally {
        isRunning.value = false
    }
}
</script>