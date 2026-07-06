<template>
 <!-- show already generated risk results    -->
    <main class="min-h-screen bg-slate-50 px-6 py-6">
        <div class="mb-6">
            <RouterLink
            to="/#prediction-results"
            class="mb-6 text-sm font-medium text-blue-600 hover:underline"
            >
                ← Back to Home
            </RouterLink>
        </div>
        <header>
            <h1 class="mt-8 text-4xl font-bold text-slate-900">
                Prediction Results
            </h1>
            <p class="mt-4 max-w-3xl text-slate-600">
                These results are based on the latest generated no-show risk scores.
            </p>
        </header>
        <!-- summary cards section -->
        <section class="mt-8 grid gap-4 md:grid-cols-4">
            <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                <p class="text-sm font-medium text-slate-500">Total Appointments</p>
                <p class="mt-2 text-2xl font-bold text-slate-900">{{ predictionSummary.total_predictions }}</p>
            </div>

            <div class="rounded-xl border border-red-200 bg-red-50 p-4">
                <p class="text-sm font-medium text-red-700">High Risk Appointments</p>
                <p class="mt-2 text-2xl font-bold text-red-800">{{ predictionSummary.high_risk }}</p>
            </div>

            <div class="rounded-xl border border-yellow-200 bg-yellow-50 p-4">
                <p class="text-sm font-medium text-yellow-700">Medium Risk Appointments</p>
                <p class="mt-2 text-2xl font-bold text-yellow-800">{{ predictionSummary.medium_risk }}</p>
            </div>

            <div class="rounded-xl border border-green-200 bg-green-50 p-4">
                <p class="text-sm font-medium text-green-700">Low Risk Appointments</p>
                <p class="mt-2 text-2xl font-bold text-green-800">{{ predictionSummary.low_risk }}</p>
            </div>
        </section>
        <!-- table here -->
        <section>
            <div class="mt-4">
                <h2 class="text-2xl font-bold text-slate-900">
                Appointment Risk Predictions for the Next 7 Days
                </h2>

                <p class="mt-2 text-slate-600">
                    Showing the latest saved prediction for each scheduled appointment in the next 7 days.
                </p>
            </div>
            <div v-if="predictionResults.length===0"
            class="mt-6 rounded-xl border border-dashed border-slate-300 bg-slate-50 p-8 text-center"
            >
                <div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-blue-100">
                    <span class="text-2xl">📊</span>
                </div>

                <h3 class="text-lg font-semibold text-slate-900">
                    No predictions generated yet
                </h3>

                <p class="mt-2 text-sm text-slate-600">
                    Please generate no-show risk predictions first to view upcoming appointment risk levels.
                </p>

                <button
                    @click="generatePredictions"
                    class="mt-5 rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700"
                >
                    Generate Predictions
                </button>
            </div>
            <div v-if="predictionResults.length>0" class="overflow-x-auto mt-4">
                <table class="min-w-full divide-y divide-slate-200">
                    <thead class="bg-slate-50">
                        <tr>
                            <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">Appointment ID</th>
                            <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">Patient ID</th>
                            <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">Appointment Date</th>
                            <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">Appointment Time</th>
                            <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">No-Show Probability</th>
                            <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">Risk Level</th>
                            <th class="px-4 py-3 text-left text-sm font-semibold text-slate-700">Generated At</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-200 bg-white">
                        <tr v-for="prediction in predictionResults" class="hover:bg-slate-50" :key="prediction.prediction_id">
                            <td class="px-4 py-3 text-sm text-slate-900">{{ prediction.appointment_id }}</td>
                            <td class="px-4 py-3 text-sm text-slate-900">{{ prediction.patient_id }}</td>
                            <td class="px-4 py-3 text-sm text-slate-900">{{ prediction.appointment_date }}</td>
                            <td class="px-4 py-3 text-sm text-slate-900">{{ prediction.appointment_time }}</td>
                            <td class="px-4 py-3 text-sm text-slate-900">{{ prediction.no_show_probability }}</td>

                            <td class="px-4 py-3 text-sm text-slate-900">
                                <span class="rounded-full px-3 py-1 font-semibold text-xs"
                                :class="{'bg-red-100 text-red-700':prediction.risk_level==='High',
                                    'bg-yellow-100 text-yellow-700': prediction.risk_level==='Medium',
                                    'bg-green-100 text-green-700':prediction.risk_level==='Low'
                                }"
                                >{{ prediction.risk_level }}</span>
                                </td>

                            <td class="px-4 py-3 text-sm text-slate-900">{{ prediction.predicted_at }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</template>
<script setup>
import {ref, onMounted} from 'vue'

const errorMessage=ref('')
const predictionResults=ref([])
const loading = ref(false)
const predictionSummary = ref({})
const isRunning=ref(false)
const successMessage = ref('')
const summary = ref({})

const days=7

const fetchPredictionResults = async ()=>{

    loading.value=true
    errorMessage.value=''

    try{
       
        const response = await fetch(`http://localhost:8000/no-show-predictions/upcoming?days=${days}`)
        const results = await response.json()

        if(!response.ok){
            throw new Error(results.detail || "Failed to fetch prediction results.")
        }
        predictionResults.value=results['predictions']
        predictionSummary.value=results['summary']
        console.log("predictionResults.value: ", predictionResults.value)

    }
    catch(error){
        console.error(error)
        errorMessage.value = 'Failed to generate predictions.'

    }
    finally{
       
        loading.value=false
    }
}


onMounted(()=>{
    fetchPredictionResults()
})

const generatePredictions = async ()=>{
    console.log("  Generate Predictions button clicked")
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