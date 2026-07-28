# ClinOps — Frontend-Only Build Prompts (Backend-Independent Track)

**Purpose:** let your frontend developer build a fully clickable, demo-ready UI for client
pilots *without waiting on the backend engineer*. This track builds against a **mock data
layer** that mirrors the real API contract from `Claude_Code_Build_Prompts.md`, so that when
the backend engineer joins, swapping mock data for real endpoints is a small, mechanical
change — not a rebuild.

**Where this fits with what you already have:**
- You've completed Module 1 (Environment & Docker Scaffolding) and Module 2 (Database Schema)
  from `Claude_Code_Build_Prompts.md`. Good — the schema from Module 2 is what this track's
  mock data models are deliberately shaped to match, so nothing here contradicts it.
- Run `UI_Generation_Prompt.md` (the shared design system) first if you haven't — this track
  assumes those shared widgets/theme already exist.
- Everything below replaces Modules 3–12 for the *frontend developer's* purposes. The backend
  engineer still builds those same modules for real against the actual database — the two
  tracks meet at Prompt 12 (Integration Handoff) below.

**Golden rule for the frontend developer:** never call a real HTTP endpoint directly from a
screen. Always go through a `Repository` interface. That one discipline is what makes this
whole approach work.

---

## 0. Contract & Mock Data Foundation (do this first — everything else depends on it)

```
Build the mock data foundation for the ClinOps Flutter app so frontend screens can be built
and demoed without a working backend, while staying a drop-in swap for the real API later.

1. Define Dart model classes matching the schema already migrated in Module 2 of
   Claude_Code_Build_Prompts.md: Patient, Visit, VisitTransition, Encounter, Diagnosis,
   LabOrder, LabResult, DrugFormularyItem, Prescription, PrescriptionItem, BillingItem,
   Payment, Referral, Admission, Ward, Bed, NursingNote, VitalsRecord, ReportSummary.
   Field names/types should mirror the migration columns so backend integration later is
   a straight mapping, not a redesign.

2. Define abstract Repository interfaces, one per domain, with method signatures that
   mirror the REST endpoints planned in Claude_Code_Build_Prompts.md modules 4–11
   (e.g., PatientRepository.search(query), PatientRepository.register(patient),
   PatientRepository.getChart(patientId), VisitRepository.transition(visitId, toState),
   ClinicalRepository.createEncounter(...), PrescriptionRepository.checkSafety(...),
   BillingRepository.getSummary(visitId), AdmissionRepository.assignBed(...), etc.)
   These interfaces are the contract — the real backend track and this mock track both
   implement the SAME interface, so UI code never needs to know which one it's talking to.

3. Implement MockXRepository classes for each interface, backed by realistic in-memory
   seed data (not empty stubs):
   - ~20 seeded patients with authentic Liberian names, mixed ages/genders, and a few
     deliberately messy records (a misspelled name, a missing phone number, two patients
     with very similar names) so the search/duplicate-detection UI has something real to
     demonstrate.
   - A seeded diagnosis catalog (~20-30 common BPHS-relevant conditions) and drug
     formulary (~20-30 common drugs with realistic dose/route/frequency options).
   - A handful of patients already mid-queue at different stations, a couple of active
     IPD admissions with beds assigned, and enough historical visits/prescriptions/lab
     results to make the patient chart view and reports look populated, not empty.
   - Mock write operations (register, transition, prescribe, dispense, pay, admit,
     discharge) should actually mutate the in-memory store and persist for the rest of
     the session, so the demo feels like a real, stateful system, not a read-only mockup.
   - Simulate realistic network behavior: ~300-800ms artificial delay on each call, and
     a toggle-able "simulate error" mode per repository method so loading and error
     states get built and tested now, not bolted on later.

4. Set up a simple service locator (get_it or similar) that resolves each Repository
   interface to its Mock implementation. Document clearly (in a code comment and in the
   README) that swapping to the real backend later means registering a different
   implementation class here — screens and widgets should never change.

Deliverable check: a developer should be able to import any Repository interface into a
screen, call its methods, and get back realistic, stateful, occasionally-slow-or-erroring
data — with zero knowledge of whether a real backend exists.
```

---

## 1. Patient Registration & Chart Retrieval (mock-backed)

```
Build the full Patient Registration and Find Patient / Chart Retrieval screens using the
PatientRepository mock from Prompt 0. Use the shared design system and widgets from the
UI Generation Prompt (SearchableSelect, PatientHeaderCard, EmptyState, etc.).

- Registration screen: full form, auto-generated hospital ID shown on save, and the
  duplicate-check flow — call the mock repository's duplicate-check method and render a
  clear "this might be the same person" comparison UI when it returns matches (use the
  seeded near-duplicate patients from Prompt 0 to verify this looks and feels right).
- Find Patient screen: the global multi-path search (ID, name, phone, DOB+community) —
  make sure a search on a partial/misspelled name against the seeded data still surfaces
  the right person, and that the empty/no-results state is graceful and suggests next
  steps (e.g., "register as new patient").
- Patient Chart screen: full visit timeline pulled from the mock repository, rendered
  clearly by date with diagnosis, prescriptions, and lab results per visit.
- Printable patient ID slip after registration (can be a simple styled view/PDF export —
  doesn't need real printer integration yet).

This screen set is the single most important thing to get right for the pilot demo, since
it's the #1 pain point ClinOps is built to solve — spend real polish time here.
```

---

## 2. Queue Engine UI (mock-backed)

```
Build the station queue screens (Reception, Vitals, Doctor, Lab, Pharmacy, Billing) as one
reusable generic queue component, backed by the mock VisitRepository from Prompt 0.

- Pull the queue list from the mock repository per station, allow staff to advance a
  patient to the next state, and reflect the change immediately in the UI (the mock
  repository actually mutates state, so this should feel real).
- Simulate "live updates" for the demo: have the mock repository emit changes on a timer
  or stream (e.g., using a simple Dart Stream the UI subscribes to) so the queue view
  updates without a manual refresh — this stands in for the real Redis/WebSocket layer
  that comes later, but should look and feel identical to the end user.
- Show clear status badges per patient (waiting, in-progress, ready-to-move) using the
  shared StatusBadge widget and the semantic colors from the design system.
```

---

## 3. Doctor Console — Structured Orders (mock-backed)

```
Build the Doctor Console using the mock Diagnosis catalog, Drug formulary, and
ClinicalRepository/PrescriptionRepository from Prompt 0.

- Diagnosis picker (SearchableSelect against the seeded catalog, multi-select).
- Prescription builder using dropdown/picker fields only (drug, dose, route, frequency,
  duration) — render each item with the shared StructuredOrderRow widget once added.
- Call the mock "safety check" method after adding a prescription item and surface any
  warning it returns (seed at least one patient with a recorded allergy so this path is
  demonstrable in the client demo).
- Clearly separated free-text "clinical notes" section, visually distinct from the
  structured order area per the design system guidance.
- Lab order picker (SearchableSelect against a seeded lab test catalog).

This is the #2 priority screen for the demo — it should visibly prove "no handwriting,
no ambiguity" when you walk a client through it.
```

---

## 4. Lab & Pharmacy Screens (mock-backed)

```
Build the Lab dashboard and Pharmacy dispensing screens against the mock
LabRepository/PrescriptionRepository from Prompt 0.

- Lab: pending orders queue (seeded + newly created from the Doctor Console in Prompt 3),
  a result-entry form matching the test type, and a simple patient-scoped result history.
- Pharmacy: pending prescriptions queue rendered via the StructuredOrderRow widget so the
  demo clearly shows a pharmacist reading clean structured data instead of handwriting.
  Dispense action should mutate mock stock counts and show a low-stock flag when a seeded
  drug's mock stock is deliberately set low, to demonstrate that feature too.
```

---

## 5. Billing Screen — Gatekeeper UI (mock-backed)

```
Build the Billing screen against the mock BillingRepository from Prompt 0.

- Itemized bill view pulling auto-generated charges from consultation/lab/pharmacy
  actions taken earlier in the demo flow for a given visit.
- Add-payment action, running balance display.
- Implement the gatekeeper rule in the mock layer too (not just as a UI note): attempting
  to transition a visit to DISCHARGE in the mock VisitRepository should fail with a clear
  error if the mock BillingRepository shows an unpaid balance for that visit — so the
  demo can actually show the block happening, not just describe it.

Note for backend integration later: the real enforcement lives in the backend's database
transaction (per CLAUDE.md); this mock-layer version exists purely so the demo can show
the rule working end-to-end before the backend is ready.
```

---

## 6. IPD — Admission, Ward/Bed, Discharge (mock-backed)

```
Build the Admission screen, Ward/Bed dashboard, and ward rounds (nursing notes + vitals)
screens against the mock AdmissionRepository/WardRepository from Prompt 0.

- Admission screen: bed picker showing live-ish availability from the seeded
  Wards/Beds mock data; block admission if no bed is selected (mirrors the real
  "cannot admit without a bed" rule).
- Ward/Bed dashboard: grid or list view of beds by ward with color-coded status badges
  (free/occupied) using the shared design system.
- Ward rounds screen (build for the mobile/tablet layout per the design system): simple
  forms for nursing notes and vitals entry against the mock admission.
- Discharge action: same gatekeeper pattern as Prompt 5 — block discharge if the mock
  billing balance for that admission is unpaid.
```

---

## 7. MoH Reporting Screens (mock-backed)

```
Build the Admin Reports screens against a mock ReportRepository from Prompt 0, seeded
with enough historical mock visits/admissions (from Prompt 0's seed data) to produce
non-trivial numbers.

- OPD summary (visit totals, diagnosis breakdown), IPD summary (admissions, occupancy,
  average length of stay), and daily summary (patient count, revenue) views, each with a
  date-range filter against the mock data.
- Export button that generates a CSV/Excel file from the currently displayed mock report
  data — this can be fully real (not mocked) since it's a pure frontend/export concern.
```

---

## 8. Pilot Demo Script & Seed Data Polish

```
Prepare the mock data and a scripted walkthrough specifically for client pilot demos.

1. Curate the seed data from Prompt 0 into a specific, repeatable "demo story": a named
   patient who has lost their ID card and must be found by name/phone (proving Prompt 1),
   a doctor visit that results in a fully structured prescription with one deliberate
   allergy warning (proving Prompt 3), a pharmacy dispense against that clean structured
   order (proving Prompt 4), and a billing flow that blocks discharge until paid, then
   succeeds (proving Prompt 5).
2. Add a "Reset Demo Data" action (admin-only, clearly labeled) that restores the mock
   store to this curated starting state, so the same demo can be re-run cleanly for
   multiple client meetings without manual cleanup.
3. Write out the actual click-by-click demo script as a short markdown file the founder/
   sales presenter can follow on stage, cross-referencing which screen proves which pain
   point.

This prompt is about polish and repeatability, not new screens — treat it as the final
pass before a client-facing demo.
```

---

## 9. Backend Integration Handoff Checklist (for when the backend engineer joins)

```
Prepare the codebase to swap from the mock data layer to the real backend built from
Claude_Code_Build_Prompts.md, with minimal changes to screens/widgets.

1. For each Repository interface, implement a matching RealXRepository class that calls
   the actual CodeIgniter API endpoints (per the module prompts already built by the
   backend engineer), returning data mapped into the same Dart model classes defined in
   Prompt 0.
2. In the service locator setup, swap the registered implementation from MockXRepository
   to RealXRepository per domain, one at a time — not all at once — so each domain can be
   verified against the real backend independently (e.g., swap PatientRepository first,
   confirm registration/search/chart still work end-to-end, then move to VisitRepository).
3. Replace the mock "live update" Stream/timer in the Queue and Ward/Bed screens (Prompt 2
   and 6) with the real WebSocket/Redis pub-sub connection once that backend module
   exists, keeping the same Stream-based interface on the UI side so no screen code needs
   to change.
4. Remove the artificial network delay/error simulation from Prompt 0 once real network
   latency is present naturally.
5. Keep the mock implementations in the codebase (don't delete them) — they remain useful
   for fast local UI iteration and offline demo fallback even after backend integration.

Verify: every screen built in Prompts 1–7 works identically after the swap, with no
screen-level code changes required — only the service locator registrations and the new
Real*Repository implementations should differ.
```
