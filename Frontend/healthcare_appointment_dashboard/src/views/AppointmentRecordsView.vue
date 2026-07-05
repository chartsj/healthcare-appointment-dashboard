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
            <h1 class="text-3xl font-bold text-slate-900">Appointment Records</h1>
            <p class="mt-2 text-slate-600">
                View all appointment records, including upcoming and past appointments, sorted by latest appointment date first.
            </p>
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
                <table v-else class="min-w-full divide-y divide-slate-200 text-left">
                    <thead class="bg-slate-100">
                        <tr>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Appointment ID</th>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Patient ID</th>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Appointment Date</th>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Appointment Time</th>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Department Name</th>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Appointment Type</th>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Appointment Status</th>
                            <th class="px-4 py-3 text-left font-semibold text-slate-700">Created At</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 bg-white">
                        <tr v-for="appointment in appointments" :key="appointment.appointment_id" class="hover:bg-slate-50">
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
                    @click="goPrevious"
                    class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100 cursor-pointer disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:bg-transparent"
                    >
                    Previous
                    </button>

                    <p>
                    Page {{ page }} of {{ totalPages }}
                    </p>

                    <button
                    :disabled="page === totalPages"
                    @click="goNext"
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
import {ref,onMounted} from 'vue'

const loading = ref(true)
const error = ref(null)
const appointments=ref([])
const page=ref(1)
const pageSize=ref(5)
const totalPages=ref(1)
const paginationInfo=ref({})


onMounted(async ()=>{
    
fetchAppointments()
})

const fetchAppointments=async()=>{
loading.value=true

    try{
        const response = await fetch(`http://localhost:8000/appointments?page=${page.value}&page_size=${pageSize.value}`)
        // 'http://localhost:8000/appointments?page=1&limit=10'

        if (!response.ok) {
        throw new Error('Failed to fetch appointments')
        }

        const data = await response.json()
       
        appointments.value = data["data"]
        
        paginationInfo.value=data["pagination"]
        
        totalPages.value=paginationInfo.value["total_pages"]
      
    // appointments.value=[{appointment_id:1,patient_id:1,appointment_date: '2025-06-05',
    //     appointment_time: '09:30:00',
    //     department_id: 1,
    //     appointment_type: 'New Consultation',
    //     appointment_status: 'Scheduled',
    //     created_at: '2025-06-01'},
    //     {appointment_id:2,patient_id:2,appointment_date: '2025-06-05',
    //     appointment_time: '09:30:00',
    //     department_id: 1,
    //     appointment_type: 'New Consultation',
    //     appointment_status: 'Scheduled',
    //     created_at: '2025-06-01'}
    // ]

    }
    catch(err){
        error.value=err
    }
    finally{
        loading.value=false
    }
}

const goNext=async()=>{
    if (page.value<totalPages.value){
        page.value++
        await fetchAppointments()
    }
    
}

const goPrevious=async()=>{
    if (page.value>1){
        page.value--
        await fetchAppointments()
    }
    
}
</script>
