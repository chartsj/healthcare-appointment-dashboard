<template>
 <!-- show already generated risk results    -->
    <main class="min-h-screen bg-slate-50 px-6 py-6">
        <div class="mb-6">
            <RouterLink
            to="/"
            class="mb-6 text-sm font-medium text-blue-600 hover:underline"
            >
                ← Back to Home
            </RouterLink>
        </div>
        <header>
            <h1 class="mt-8 text-4xl font-bold text-slate-900">
                No-Show Risk Prediction Results 
            </h1>
            <p class="mt-4 max-w-3xl text-slate-600">
                View the latest predicted no-show risk for appointments scheduled in the next 7 days. High-risk appointments may need follow-up reminders or additional patient outreach.
            </p>
        </header>
        <!-- summary cards section -->
        <section class="mt-8 grid gap-4 md:grid-cols-4">
            <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
                <p class="text-slate-500">Total Predicted</p>
                <p class="mt-2 text-3xl font-bold text-slate-900">12</p>
            </div>

            <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
                <p class="text-slate-500">High Risk</p>
                <p class="mt-2 text-3xl font-bold text-slate-900">3</p>
            </div>

            <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
                <p class="text-slate-500">Medium Risk</p>
                <p class="mt-2 text-3xl font-bold text-slate-900">5</p>
            </div>

            <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
                <p class="text-slate-500">Low Risk</p>
                <p class="mt-2 text-3xl font-bold text-slate-900">4</p>
            </div>
        </section>
        <!-- table here -->
        <section>
            <div class="mb-4">
                <h2 class="text-2xl font-bold text-slate-900">
                Next 7 Days Appointment Risks
                </h2>

                <p class="mt-2 text-slate-600">
                These results show the latest saved prediction for each appointment scheduled within the next 7 days.
                </p>
            </div>
        </section>
    </main>
</template>