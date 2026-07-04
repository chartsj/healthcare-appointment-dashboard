<template>
  <main class="min-h-screen bg-slate-50 px-6 py-10">
    <section class="mx-auto max-w-4xl">
      <RouterLink
        to="/"
        class="mb-6 text-sm font-medium text-blue-600 hover:underline"
      >
        ← Back to Home
      </RouterLink>

        <div class="rounded-2xl bg-white p-8 shadow-sm border border-slate-200">
            <h1 class="text-3xl font-bold text-slate-900">
                No-Show Risk Prediction
            </h1>
            <section>
                <div v-if="loading">
                    Running predictions...
                </div>
                <div v-else-if="error">
                    {{error}}
                </div>
                <div v-else>
                    <p>hi world</p>
                    <table>
                    </table>
                </div>
            </section>


       
      </div>
    </section>
  </main>
</template>
<script setup>
import {ref,onMounted} from 'vue'
const loading = ref(true)
const error = ref(null)
const results = ref([])
onMounted(async ()=>{
    try{
        const response = await fetch('http://localhost:3000/api/appointments/upcoming')
        //results.value = response
        results.value='hi'
    }
    catch (err){
        error.value=err
    }
    finally{
        loading.value=false
    }
})
</script>