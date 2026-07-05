<template>
    <main class="min-h-screen bg-slate-50 px-6 py-4">
        <div class="mb-6">
            <RouterLink
            to="/"
            class="mb-6 text-sm font-medium text-blue-600 hover:underline"
            >
                ← Back to Home
            </RouterLink>
        </div>
        <header>
            <h1 class="text-3xl font-bold text-slate-900">
            Create New Appointments
            </h1>

            <p class="mt-2 text-slate-600">
                Add a new scheduled appointment for an existing patient.
            </p>
        </header>
        <section class="mt-6">
            <form class="space-y-6" @submit.prevent="createAppointment">
                <div>
                    <label class="block text-sm font-medium text-slate-700">Patient ID</label>
                    <input v-model="form.patient_id" type="number" required  
                     placeholder="Enter patient ID"
                    class="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"/>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700">Appointment Date</label>
                    <input v-model="form.appointment_date" type="date"
                    class="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"
                    required/>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700">Appointment Time</label>
                    <input v-model="form.appointment_time" type="time" 
                    class="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"
                    required/>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700">Department ID</label>
                    <select v-model="form.department_id" required class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2">
                        <option value="">Select department</option>
                        <option value="1">Cardiology</option>
                        <option value="2">Orthopaedics</option>
                        <option value="3">General Medicine</option>
                        <option value="4">Dermatology</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700">Appointment Type</label>
                    <select v-model="form.appointment_type" required class="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200">
                        <option value="">Select type</option>
                        <option value="1">New Consultation</option>
                        <option value="2">Follow-up</option>
                        <option value="3">Screening</option>
                        <option value="4">Procedure</option>
                    </select>
                </div>
                <p
                    v-if="successMessage"
                    class="rounded-lg bg-green-50 px-4 py-2 text-sm text-green-700"
                >
                    {{ successMessage }}
                </p>

                <p
                    v-if="errorMessage"
                    class="rounded-lg bg-red-50 px-4 py-2 text-sm text-red-700"
                >
            {{ errorMessage }}
                </p>
                <div class="pt-2">
                    <button
                    :disabled="isSubmitting"
                    type="submit"
                    class="rounded-lg bg-blue-600 px-5 py-2 font-medium text-white hover:bg-blue-700"
                    >
                    {{ isSubmitting?'Creating...':'Create Appointment' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
<script setup>
import {ref,reactive} from 'vue'

const form = reactive({
    patient_id:'',
    department_id:'',
    appointment_date: '',
  appointment_time: '',
  appointment_type: ''
})

const isSubmitting=ref(false)
const successMessage = ref('')
const errorMessage = ref('')

const createAppointment = async () => {
  try {
    isSubmitting.value = true
    successMessage.value = ''
    errorMessage.value = ''

    const response = await fetch('http://localhost:8000/appointments', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        patient_id: Number(form.patient_id),
        appointment_date: form.appointment_date,
        appointment_time: form.appointment_time,
        department_id: Number(form.department_id),
        appointment_type: form.appointment_type,
        // appointment_status: 'Scheduled'
      })
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }

    const data = await response.json()
    console.log('Created appointment:', data)

    successMessage.value = 'Appointment created successfully.'

    form.patient_id = ''
    form.appointment_date = ''
    form.appointment_time = ''
    form.department_id = ''
    form.appointment_type = ''

  } catch (error) {
    console.error('Failed to create appointment:', error)
    errorMessage.value = 'Failed to create appointment.'
  } finally {
    isSubmitting.value = false
  }
}
</script>