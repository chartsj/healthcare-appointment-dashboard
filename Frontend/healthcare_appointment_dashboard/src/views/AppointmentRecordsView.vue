<template>
    <main class="min-h-screen bg-slate-50 px-6 py-10">
        <div class="mb-6">
            <RouterLink
            to="/"
            class="mb-6 text-sm font-medium text-blue-600 hover:underline"
            >
                ← Back to Home
            </RouterLink>
        </div>
        <header>
            <h1 class="text-3xl font-bold text-slate-900">Appointment Records</h1>
            <p class="mt-2 text-slate-600">View historical and upcoming appointment records, including appointment dates, departments, appointment</p>
        </header>
        <!-- summary cards -->
        <!-- <section class="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-5">
            <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                <p class="text-sm text-slate-500">Total Appointments</p>
                <p class="mt-2 text-2xl font-bold text-slate-900">12</p>
            </div>
            <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                <p class="text-sm text-slate-500">Scheduled</p>
                <p class="mt-2 text-2xl font-bold text-slate-900">8</p>
            </div>
            <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                <p class="text-sm text-slate-500">No Show</p>
                <p class="mt-2 text-2xl font-bold text-slate-900">1</p>
            </div>
            <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                <p class="text-sm text-slate-500">Cancelled</p>
                <p class="mt-2 text-2xl font-bold text-slate-900">3</p>
            </div>
        </section> -->
        <section>
            
            <!-- filter -->

            <!-- table -->
            <p v-if='loading'>Retrieving appointment records...</p>
            <p v-else-if='error'>{{error}}</p>
            <div v-else class="overflow-x-auto">
                <p v-if="appointments.length===0">
                    No appointment records found.
                </p>
                <table v-else class="w-full text-left">
                    <thead>
                        <tr>
                            <th>Appointment ID</th>
                            <th>Patient ID</th>
                            <th>Appointment Date</th>
                            <th>Appointment Time</th>
                            <th>Department Name</th>
                            <th>Appointment Type</th>
                            <th>Appointment Status</th>
                            <th>Created At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="appointment in appointments" :key="appointment.appointment_id">
                            <td class="px-4 py-3">{{appointment.appointment_id}}</td>
                            <td class="px-4 py-3">{{appointment.patient_id}}</td>
                            <td class="px-4 py-3">{{appointment.appointment_date}}</td>
                            <td class="px-4 py-3">{{appointment.appointment_time}}</td>
                            <td class="px-4 py-3">{{appointment.department_id}}</td>
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
                    :disabled="currentPage === 1"
                    @click="goPrevious"
                    >
                    Previous
                    </button>

                    <p>
                    Page {{ currentPage }} of {{ totalPages }}
                    </p>

                    <button
                    :disabled="currentPage === totalPages"
                    @click="goNext"
                    >
                    Next
                    </button>
                </div>
                
            </div>

        </section>
    </main>
</template>

<script setup>
import {ref,onMounted} from 'vue'

const loading = ref(true)
const error = ref(null)
const appointments=ref([])
onMounted(async ()=>{
    loading.value=true

    try{
    //     const response = await fetch('http://localhost:3000/api/appointments?page=1&limit=10')

    //     if (!response.ok) {
    //     throw new Error('Failed to fetch appointments')
    //     }

    // const data = await response.json()
    // appointments.value = data.appointments
    appointments.value=[{appointment_id:1,patient_id:1,appointment_date: '2025-06-05',
        appointment_time: '09:30:00',
        department_id: 1,
        appointment_type: 'New Consultation',
        appointment_status: 'Scheduled',
        created_at: '2025-06-01'},
        {appointment_id:2,patient_id:2,appointment_date: '2025-06-05',
        appointment_time: '09:30:00',
        department_id: 1,
        appointment_type: 'New Consultation',
        appointment_status: 'Scheduled',
        created_at: '2025-06-01'}
    ]

    }
    catch(err){
        error.value=err
    }
    finally{
        loading.value=false
    }

})
</script>
