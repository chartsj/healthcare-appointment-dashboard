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

        <p class="mt-2 text-slate-600">
          Enter appointment details to estimate the patient's no-show risk.
        </p>

        <form class="mt-8 space-y-5">
          <div>
            <label class="block text-sm font-medium text-slate-700">
              Appointment Type
            </label>
            <select class="mt-1 w-full rounded-lg border border-slate-300 p-3">
              <option>New Consultation</option>
              <option>Follow-up</option>
              <option>Screening</option>
              <option>Procedure</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-slate-700">
              Department
            </label>
            <select class="mt-1 w-full rounded-lg border border-slate-300 p-3">
              <option>Cardiology</option>
              <option>Orthopaedics</option>
              <option>General Medicine</option>
              <option>Dermatology</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-slate-700">
              Previous No-Show Count
            </label>
            <input
              type="number"
              min="0"
              class="mt-1 w-full rounded-lg border border-slate-300 p-3"
              placeholder="e.g. 1"
            />
          </div>

          <button
            type="button"
            class="rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700"
          >
            Calculate Risk
          </button>
        </form>
      </div>
    </section>
  </main>
</template>