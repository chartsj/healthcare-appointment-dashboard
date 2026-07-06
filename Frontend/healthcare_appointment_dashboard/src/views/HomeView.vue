<script setup>
import { ref } from 'vue'


const count = ref(0)
</script>

<template>
  <main class="min-h-screen bg-slate-50 px-6 py-10">
    
    <section class="mx-auto max-w-5xl space-y-6">
        <div class='mb-8 px-8'>
            <h1 class="text-4xl font-bold text-[#00A950]">
                Healthcare Appointment Dashboard
            </h1>
            <p class="mt-4 max-w-2xl text-slate-600">
                View appointment records, monitor upcoming appointments,
                and generate no-show risk predictions.
            </p>
        </div>
      <div id="create-appointment" class="rounded-2xl bg-white p-8 shadow-sm border border-slate-200">
        <h1 class="mt-3 text-4xl font-bold text-slate-900">Create New Appointment</h1>
        <p class="mt-4 max-w-2xl text-slate-600">
             Add a new scheduled appointment for an existing patient.
        </p>
        <div class="mt-8">
         <RouterLink to="/appointments/create" class="rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700">
            Create Appointment
         </RouterLink>
        </div>
      </div>
      <div id="appointment-records" class="rounded-2xl bg-white p-8 shadow-sm border border-slate-200">
        <h1 class="mt-3 text-4xl font-bold text-slate-900">Appointment Records</h1>
        <p class="mt-4 max-w-2xl text-slate-600">View historical and upcoming appointment records, including appointment status.</p>  
        <div class="mt-8"> 
            <RouterLink to='appointment-records' class="rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700">
                View Appointment Records
            </RouterLink>
        </div>
      </div>
      <div id="upcoming-appointments" class="rounded-2xl bg-white p-8 shadow-sm border border-slate-200">
        <h1 class="mt-3 text-4xl font-bold text-slate-900">Upcoming Appointments</h1>
        <p class="mt-4 max-w-2xl text-slate-600">
            View scheduled appointments in the next 7 days.
        </p>
        <div class="mt-8">
         <RouterLink to="/appointments" class="rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700">
            View Upcoming Appointments
         </RouterLink>
        </div>
      </div>
      
      <div id="generate-risk" class="rounded-2xl bg-white p-8 shadow-sm border border-slate-200">

        <h1 class="mt-3 text-4xl font-bold text-slate-900">
          Generate Patient No-Show Risk
        </h1>

        <p class="mt-4 max-w-2xl text-slate-600">
          Generate no-show risk scores for upcoming appointments, based on appointment and
          patient-related factors.
        </p>

        <div class="mt-8">
          <RouterLink
            to="/predict"
            class="rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700"
          >
            Open Prediction Tool
        </RouterLink>
        </div>
      </div>
      <div id="prediction-results" class="rounded-2xl bg-white p-8 shadow-sm border border-slate-200">
        <h1 class="mt-3 text-4xl font-bold text-slate-900">
            Prediction Results
        </h1>
        <p class="mt-4 max-w-2xl text-slate-600">
            View saved no-show risk predictions for scheduled appointments within the next 7 days. 
        </p>
        <div class="mt-8">
            <RouterLink to='prediction-results' class="rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700">
                View Prediction Results
            </RouterLink>
        </div>
      </div>
      
    </section>
  </main>

</template>
