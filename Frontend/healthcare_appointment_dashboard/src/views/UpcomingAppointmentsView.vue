<template>
    <main class="min-h-screen bg-slate-50 px-6 py-4">
        <div class="mb-6">
            <RouterLink
            to="/#upcoming-appointments"
            class="mb-6 text-sm font-medium text-blue-600 hover:underline"
            >
                ← Back to Home
            </RouterLink>
        </div>
        <header>
            <h1 class="text-3xl font-bold text-slate-900">
            Upcoming Appointments
            </h1>

            <p class="mt-2 text-slate-600">
            Appointments scheduled in the next 7 days.
            </p>
        </header>
        <section class="mt-8 grid gap-4 sm:grid-cols-2">
            <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                <p class="text-sm text-slate-500">Total Upcoming</p>
                <p class="mt-2 text-2xl font-bold text-slate-900">{{ upcomingAppointmentsCount===null?'N/A':upcomingAppointmentsCount }}</p>
            </div>
            <!-- <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                <p class="text-sm text-slate-500">Departments</p>
                <p class="mt-2 text-2xl font-bold text-slate-900">4</p>
            </div> -->

        </section>
        
        <section class="mt-8 rounded-2xl border border-slate-200 bg-white shadow-sm">
            <div v-if="loading" class="mt-8 rounded-xl bg-white p-6 shadow-sm">
                Loading appointments...
            </div>
            <div v-else-if="error" class="mt-8 rounded-xl bg-white p-6 text-red-600">
                {{ error }}
            </div>
            <div v-else class="overflow-x-auto">
                <table class="min-w-full divide-y divide-slate-200 text-left">
                    <thead class="bg-slate-100 text-slate-700">
                        <tr>
                            <th class="px-4 py-3 font-semibold">Appointment ID</th>
                            <th class="px-4 py-3 font-semibold">Patient ID</th>
                            <th class="px-4 py-3 font-semibold">Appointment Date</th>
                            <th class="px-4 py-3 font-semibold">Appointment Time</th>
                            <th class="px-4 py-3 font-semibold">Department Name</th>
                            <th class="px-4 py-3 font-semibold">Appointment Type</th>
                            <th class="px-4 py-3 font-semibold">Appointment Status</th>
                            <th class="px-4 py-3 font-semibold">Created At</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-200">
                        <tr class="hover:bg-slate-50" v-for="appointment in appointments" :key="appointment.appointment_id">
                            <td class="px-4 py-3">{{appointment.appointment_id}}</td>
                            <td class="px-4 py-3">{{appointment.patient_id}}</td>
                            <td class="px-4 py-3">{{appointment.appointment_date}}</td>
                            <td class="px-4 py-3">{{appointment.appointment_time}}</td>
                            <td class="px-4 py-3">{{appointment.department_name}}</td>
                            <td class="px-4 py-3">{{appointment.appointment_type}}</td>
                            <td class="px-4 py-3">{{appointment.appointment_status}}</td>
                            <td class="px-4 py-3">{{appointment.created_at}}</td>
                        </tr>
                    </tbody>
                </table>
                <!-- Pagination here -->
                <div
                    v-if="appointments.length > 0"
                    class="mt-6 flex items-center justify-center gap-3"
                >
                    <button
                    :disabled="page === 1"
                    @click="goPreviousAppointments"
                    class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100 cursor-pointer disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:bg-transparent"
                    >
                    Previous
                    </button>

                    <p>
                    Page {{ page }} of {{ paginationSummary.total_pages }}
                    </p>

                    <button
                    :disabled="page === paginationSummary.total_pages"
                    @click="goNextAppointments "
                    class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100 cursor-pointer disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:bg-transparent"
                    >
                    Next
                    </button>
                </div>
            </div>
        </section>
    </main>

</template>
<script setup>
import {ref, onMounted} from 'vue'

const appointments = ref([])
const loading = ref(true)
const error = ref(null)
const upcomingAppointmentsCount=ref(null)
const page_size=5
const page=ref(1)

const paginationSummary=ref({})


const fetchUpcomingAppointments = async()=>{
    try{
        const response = await fetch(`http://localhost:8000/appointments/upcoming?days=7&page=${page.value}&page_size=${page_size}`)
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`)
        }

        const data = await response.json()
        appointments.value = data['data']
        upcomingAppointmentsCount.value=data['pagination']['total']
        paginationSummary.value = data['pagination']

    }
    catch (err){
        error.value=err
    }
    finally{
        loading.value=false
    }
}
onMounted(async ()=>{
    fetchUpcomingAppointments()
})


const goNextAppointments = async()=>{
    if (page.value < paginationSummary.value.total_pages) {
    page.value++
    await fetchUpcomingAppointments()
  }
}

const goPreviousAppointments = async()=>{
    if (page.value >1) {
    page.value--
    await fetchUpcomingAppointments()
  }
}

</script>