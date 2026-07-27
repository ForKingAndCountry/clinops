# Claude Code Build Prompts — Clinic MVP (OPD + IPD + MoH Compliance)

**Stack:** Flutter (Web + Mobile builds) · PHP CodeIgniter 4 · MySQL 8 · Nginx · Redis · Docker (offline-first)
**Target:** Pilot-ready single-facility MVP by end of August 2026

## How to use this document

Work through the prompts **in order** — each one assumes the previous ones are done. Paste the "Project Context" prompt first and save it as `CLAUDE.md` in your repo root so Claude Code keeps it as persistent context for every session. Then paste each numbered module prompt into Claude Code as its own task, review/test the output, commit, and move to the next.

Don't paste multiple module prompts in one go — building and verifying one vertical slice at a time (schema → API → screen) is what keeps a 6–7 week timeline realistic.

---

## 0. Project Context (save as `CLAUDE.md`)

```
You are building a clinic management system (OPD + IPD) for a private clinic in Liberia,
designed to run fully OFFLINE on local hardware via Docker, on a local WiFi/LAN network.

STACK:
- Backend: PHP, CodeIgniter 4 (MVC, RESTful API). Use CodeIgniter Shield for auth/RBAC.
- Database: MySQL 8. All money- and bed-state-changing operations MUST use DB transactions
  with row-level locking to prevent race conditions across simultaneous station users.
- Cache/Session/Realtime: Redis — used for sessions, dashboard caching, and pub/sub.
- Frontend: Flutter, two build targets from one codebase:
  - Web build: used at fixed station terminals (Reception, Vitals, Doctor, Lab, Pharmacy,
    Billing, Admin). Must be lightweight — assume old, low-RAM desktop hardware. Avoid
    heavy animations and deep widget trees on these screens.
  - Mobile/Tablet build: used for bedside IPD workflows (ward nursing notes, vitals
    charting, doctor rounds).
- Web server: Nginx reverse-proxying PHP-FPM and serving the Flutter web build.
- Everything runs in Docker Compose: nginx, php-fpm(CI4), mysql, redis containers.
  Containers use `restart: unless-stopped` (local power reliability is a real concern).

TWO NON-NEGOTIABLE PRIORITIES (these are the actual pain points driving this build):

1. PATIENT IDENTITY & CHART RETRIEVAL
   Clinics currently lose access to patient history whenever a physical hospital ID
   card/number is lost. Every patient must be findable via multiple paths — hospital ID,
   name (fuzzy/partial match), phone number, or DOB + community — never via ID number
   alone. Registration must actively check for likely duplicate patients (name + DOB +
   phone proximity) and offer a merge/link flow. A patient's full visit history
   (diagnoses, prescriptions, lab results, admissions) must always be reachable once
   the patient is found — this history IS "the chart."

2. STRUCTURED CLINICAL ORDERS — NO HANDWRITING AMBIGUITY
   Practitioners currently give patients the wrong treatment because a doctor's/screener's
   handwriting is misread. Nothing that reaches Lab or Pharmacy may depend on free-text
   interpretation. Diagnoses are selected from a coded/searchable list. Prescriptions are
   built from structured fields — drug (from formulary), dose, route, frequency, duration —
   chosen via pickers/dropdowns, never typed as a sentence. A separate free-text
   "clinical notes" field may exist for the doctor's own record, but it is never what
   Pharmacy or Lab acts on.

KEY BUSINESS RULES (enforce at the Service layer, not just the UI):
- Billing Gatekeeper: a visit/admission cannot be marked DISCHARGED while unpaid billing
  items exist. Enforce this as a DB-transaction-level check, not just a UI disable.
- Bed Allocation: cannot admit a patient without assigning a specific bed; bed status
  changes must be atomic to prevent double-booking under concurrent access.
- State Integrity: Visit and Admission status transitions are controlled (no skipping
  required steps) and every transition is written to an audit/log table with actor + timestamp.
- Auditability: every create/update/delete of clinical, billing, or admission data is logged.

CODE CONVENTIONS:
- CodeIgniter 4: one Controller + Model + Service class per domain (Patient, Visit, Queue,
  Clinical, Lab, Pharmacy, Billing, Admission, Ward, Reporting). Controllers stay thin —
  business rules live in Services so they're enforced consistently across the API.
- Validation via CI4's built-in Validation library on every write endpoint.
- All API responses are JSON; errors return a consistent {status, message, errors} shape.
- Flutter: use Provider or Riverpod for state management (pick one and stay consistent).
  Keep API calls in a dedicated service/repository layer, not inside widgets.

Ask before assuming scope beyond what's described in a given prompt — this is a tightly
timeboxed MVP for an August pilot, not the full long-term product.
```

---

## 1. Environment & Docker Scaffolding

```
Set up the base project structure for the clinic system described in CLAUDE.md.

1. Create a docker-compose.yml with services: nginx, php (CodeIgniter 4 on php-fpm),
   mysql (8.0), redis (7). All services on a shared internal network, restart policy
   `unless-stopped`, named volumes for mysql data and any uploaded files.
2. Scaffold a fresh CodeIgniter 4 project under /backend, configured to connect to the
   mysql and redis containers via environment variables (.env), not hardcoded values.
3. Add an nginx config that reverse-proxies /api/* to the CodeIgniter app and is ready
   to also serve a Flutter web build from /web (static files) once that exists.
4. Scaffold a Flutter project under /frontend with two entry-point flavors/build
   configs: `web` and `mobile`. Add an ApiClient class that reads the API base URL from
   a build-time config so it can point at the same backend from either build.
5. Add a root README with `docker compose up` instructions and how to run Flutter for
   each target.

Verify: containers start cleanly, hitting /api/health on CodeIgniter returns a JSON
200 OK, and the Flutter web build loads a placeholder screen that successfully calls
that health endpoint.
```

---

## 2. Database Schema — Core Tables

```
Using CodeIgniter 4 migrations, create the initial schema. Base it on this table list,
adding sensible columns/types/foreign keys/indexes (include created_at/updated_at and
soft-delete where appropriate):

Patients, Visits, Visit_Transitions, Encounters (doctor consultation), Diagnoses_Catalog
(coded diagnosis list), Lab_Orders, Lab_Results, Drug_Formulary, Prescriptions,
Prescription_Items (structured drug/dose/route/frequency/duration), Billing_Items,
Payments, Referrals, Admissions, Wards, Beds, Nursing_Notes, Vitals_Records, Users,
Roles/Permissions (if not fully handled by CodeIgniter Shield), Audit_Logs.

Important schema notes:
- Patients needs a unique, human-friendly hospital_id (generated, not user-typed) PLUS
  indexed columns for name, phone, dob, and community/address to support multi-path
  search. Add a patients_possible_duplicates or duplicate-check support (e.g., a
  normalized-name column for fuzzy matching).
- Prescription_Items must NOT have a single free-text "instructions" field as the
  primary data — drug_id, dose, dose_unit, route, frequency, duration all need their
  own structured columns/foreign keys to lookup tables. A separate optional notes
  field is fine.
- Beds needs a status enum (free/occupied/maintenance) and a foreign key to the current
  admission when occupied — write the migration so a bed can only reference one active
  admission at a time (enforce in the Service layer with a transaction + row lock,
  document that requirement in a code comment on the model).
- Audit_Logs: table_name, record_id, action, actor_user_id, before_json, after_json, timestamp.

Output: the migration files plus a short schema diagram summary in markdown.
```

---

## 3. Auth & RBAC

```
Implement authentication and role-based access control using CodeIgniter Shield.

Roles: ClinicAdmin, Doctor, Nurse, LabTech, Pharmacist, WardNurse, AdmissionManager,
InpatientDoctor, RecordsOfficer, BillingOfficer.

Requirements:
- Login endpoint returning a session/token usable by the Flutter clients.
- Redis used as the session store.
- Middleware/filters restricting each API route group to the roles that should access it
  (e.g., only Pharmacist can hit the dispensing-confirmation endpoint).
- A simple seeded admin user + role list for local/dev setup.
- Flutter: a login screen (works on both web and mobile builds) and an auth-aware API
  client that attaches the session/token and redirects to login on 401.

Verify: each role can log in and only see/hit endpoints appropriate to that role;
unauthorized requests return 403 with the standard error shape from CLAUDE.md.
```

---

## 4. Patient Registration & Chart Retrieval (P0 — Priority #1)

```
Build the patient registration and search/retrieval module — this is the highest-priority
module in the whole system per CLAUDE.md.

Backend (CodeIgniter 4):
- POST /api/patients — register a new patient (name, gender, dob or age, phone,
  community/address, next of kin). Auto-generate a unique, human-readable hospital_id.
  Before saving, run a duplicate-check query (name similarity + dob + phone proximity)
  and return any likely matches in the response so the UI can prompt "is this the same
  person?" before creating a new record.
- POST /api/patients/{id}/merge — merge two patient records (reassign visits/encounters/
  admissions from the duplicate into the primary record, soft-delete the duplicate,
  write an audit log entry).
- GET /api/patients/search?q=... — multi-path search: match against hospital_id, name
  (partial/fuzzy), phone number, or dob+community combination. Return enough fields
  (name, hospital_id, dob, phone, thumbnail info) for a results list, ranked by best match.
- GET /api/patients/{id}/chart — full history: all visits, encounters/diagnoses,
  prescriptions, lab results, and admissions for this patient, ordered by date.

Frontend (Flutter, web build primarily — this runs at Reception):
- Registration screen with the duplicate-warning flow described above.
- A prominent, fast "Find Patient" search screen: single search box that hits the
  multi-path search endpoint, results list showing enough info to disambiguate,
  and a clear path for "patient has no ID card / doesn't remember their ID" that still
  finds them via name/phone/dob.
- Patient chart view: timeline of all past visits/diagnoses/prescriptions/lab
  results/admissions, readable at a glance.
- Printable/exportable patient ID slip after registration (name, hospital_id, barcode
  or simple code optional).

Verify with realistic messy test data: misspelled names, missing phone numbers, patients
sharing a common name — confirm search still surfaces the right person and duplicate
detection fires appropriately without over-triggering on genuinely different patients.
```

---

## 5. Visit Lifecycle & Queue Engine ("The Mover")

```
Implement the OPD visit lifecycle and station queue system.

Backend:
- POST /api/visits — start a visit for a patient (visit_type: OPD/IPD/Maternity/
  Emergency), initial state RECEPTION.
- POST /api/visits/{id}/transition — move a visit to its next state, validating the
  transition is allowed (no skipping stations) and logging to Visit_Transitions
  (from_state, to_state, actor, timestamp) inside a DB transaction.
- GET /api/queue/{station} — list patients currently queued at a given station,
  ordered by arrival/priority.
- Default OPD flow: RECEPTION → VITALS → DOCTOR → LAB → PHARMACY → BILLING → DISCHARGE.

Frontend (Flutter web, one lightweight screen per station):
- A generic "station queue" screen reusable across Reception/Vitals/Lab/Pharmacy/Billing,
  showing who's waiting and letting staff pull the next patient and advance their state.
- Keep this screen intentionally simple/fast — it will be open all day on modest hardware.

Note: full real-time push updates are handled in a later prompt (Redis pub/sub +
WebSocket). For now, poll GET /api/queue/{station} every few seconds — make the polling
interval configurable so it's trivial to replace with a push-based update later.
```

---

## 6. Structured Doctor Consultation (P0 — Priority #2)

```
Build the doctor consultation module. This module exists specifically to eliminate
handwriting-driven treatment errors, per CLAUDE.md — do not add any free-text field
that Lab or Pharmacy will act on.

Backend:
- GET /api/diagnoses/search?q=... — search the coded Diagnoses_Catalog (seed it with a
  lightweight BPHS-relevant list: malaria, common infectious diseases, maternal
  conditions, etc. — a few dozen entries is enough for pilot, not a full ICD-10 import).
- POST /api/encounters — create a consultation record: patient/visit id, one or more
  diagnosis_id references (from the catalog, not free text), a separate optional
  free-text clinical_notes field clearly marked as doctor-reference-only.
- POST /api/prescriptions — structured order: one or more Prescription_Items, each with
  drug_id (from Drug_Formulary), dose, dose_unit, route, frequency, duration — all
  selected values, not typed sentences.
- POST /api/prescriptions/{id}/check-safety — basic check against the patient's recorded
  allergies and currently active prescriptions, returning warnings (not hard blocks,
  but clearly flagged) for the doctor to see before finalizing.
- POST /api/lab-orders — structured lab test order referencing a Lab_Test_Catalog entry.

Frontend (Flutter web, Doctor console):
- Diagnosis picker: type-ahead search against the coded catalog, multi-select.
- Prescription builder: for each drug, dropdowns/pickers for dose/route/frequency/
  duration sourced from the formulary — never a free-text instructions box as the
  primary input. Show the allergy/duplicate-therapy warning inline if triggered.
- Lab order picker: same type-ahead pattern against the lab test catalog.
- Clearly visually separate the structured order area from the optional free-text
  clinical notes area, so it's obvious to the doctor which one pharmacy/lab will see.

Verify: create a prescription entirely through pickers with zero typing required for
drug/dose/route/frequency/duration, and confirm the data reaching Pharmacy in the next
module is fully structured (no ambiguity, nothing to "misread").
```

---

## 7. Lab Module

```
Build the lab ordering and results module.

Backend:
- GET /api/lab-orders?station=lab — queue of pending lab orders (from the structured
  orders created in the doctor module).
- POST /api/lab-orders/{id}/result — record structured result (numeric/text per test
  type, plus a normal/abnormal flag where applicable), update order status to completed.
- Result completion should trigger a queue-visible notification (poll-based for now)
  so the doctor/pharmacy step can proceed.

Frontend (Flutter web, Lab dashboard):
- Pending orders queue for the lab station.
- Result entry screen matching the fields for the ordered test type.
- Simple result history lookup by patient.
```

---

## 8. Pharmacy — Dispensing Against Structured Orders

```
Build the pharmacy dispensing module. This is the second half of eliminating
handwriting-driven errors — pharmacy must never need to interpret anything, only confirm
against clean structured data.

Backend:
- GET /api/prescriptions?station=pharmacy — pending prescriptions queue.
- POST /api/prescriptions/{id}/dispense — record dispensing: quantity given, dispensed_by
  user, timestamp; update Prescription_Items status; decrement basic stock count on
  Drug_Formulary/inventory; flag if stock goes below a low-stock threshold.
- Every dispense action writes to Audit_Logs.

Frontend (Flutter web, Pharmacy screen):
- Queue of pending prescriptions, each rendered as clean structured fields (drug, dose,
  route, frequency, duration) exactly as the doctor selected them — this view is the
  proof that handwriting is no longer in the loop.
- Dispense confirmation action, with a low-stock indicator on the drug if relevant.

Note: full inventory automation (reordering, supplier integration) is explicitly
post-pilot per the roadmap — keep this to stock counts and a low-stock flag only.
```

---

## 9. Billing Gatekeeper

```
Build the billing module, implementing the hard rule from CLAUDE.md: no discharge while
unpaid billing items exist.

Backend:
- Billing_Items are auto-created when consultation, lab, and pharmacy actions occur
  (hook into those services rather than requiring manual entry for standard services).
- POST /api/billing/{visit_id}/payments — record a payment (amount, method), update
  running balance.
- GET /api/billing/{visit_id}/summary — itemized bill + balance.
- Enforce the gatekeeper INSIDE the visit-transition Service (from module 5): a
  transition to DISCHARGE must fail with a clear error if unpaid Billing_Items exist
  for that visit — wrap the check and the transition in the same DB transaction.

Frontend (Flutter web, Billing screen):
- Itemized bill view, add-payment action, and a visible "cannot discharge — balance
  due" state that mirrors the backend rule (UI convenience only; the backend is the
  real enforcement).
```

---

## 10. IPD — Admission, Ward/Bed, Discharge (Lightweight MVP Slice)

```
Build the inpatient module, scoped to the MVP essentials (full depth is post-pilot).

Backend:
- POST /api/admissions — admit a patient (from an existing OPD visit or directly),
  requiring a diagnosis reference and a specific bed assignment in the same transaction
  (Rule: cannot admit without a bed; cannot double-assign a bed — use row locking).
- Wards/Beds CRUD (basic ward types: Male/Female/Pediatric) and a bed-status endpoint.
- POST /api/admissions/{id}/daily-charge — accrue a daily bed charge (can be a simple
  scheduled job or triggered on a daily-rounds check-in — keep it simple for MVP).
- Nursing_Notes and Vitals_Records endpoints (create/list per admission) for ward staff.
- POST /api/admissions/{id}/discharge — same billing-gatekeeper rule as OPD: blocked
  while unpaid items exist. On success, record discharge summary, final diagnosis,
  and compute length of stay.

Frontend:
- Flutter web: Admission screen (bed picker showing real-time-ish availability),
  ward/bed admin screen.
- Flutter mobile/tablet build: ward rounds screen for nursing notes + vitals charting,
  designed for bedside use on a tablet.
```

---

## 11. MoH BPHS Reporting

```
Build the reporting module. Because diagnoses, visit types, and admissions are already
structured/coded from earlier modules, this is mostly aggregation, not new capture.

Backend:
- GET /api/reports/opd-summary?from=&to= — total OPD visits, disease/diagnosis
  breakdown (using the coded Diagnoses_Catalog).
- GET /api/reports/ipd-summary?from=&to= — total admissions, bed occupancy rate,
  average length of stay, discharges (alive/deceased if tracked), top diagnoses.
- GET /api/reports/daily-summary — patient count, revenue for a given day.
- All report endpoints support CSV/Excel export (formatted cleanly for direct MoH
  submission — clear headers, no raw IDs where a label is expected).

Frontend (Flutter web, Admin dashboard):
- Report selection + date range screen, preview table, and an export/download button
  per report.
```

---

## 12. Real-Time Queue & Bed Dashboards

```
Upgrade the polling-based queue (module 5) and bed status (module 10) views to
real-time, per CLAUDE.md's Redis pub/sub approach.

Backend:
- On any visit-transition or bed-status change, publish an event to a Redis channel
  (e.g., `queue:{station}` or `beds:{ward_id}`).
- Add a small dedicated WebSocket service (PHP Workerman/Ratchet process or a minimal
  Node.js microservice — your choice, document which) that subscribes to Redis and
  pushes updates to connected Flutter clients.
- Keep the existing polling code path as an automatic fallback if the WebSocket
  connection isn't available, so the system degrades gracefully rather than breaking.

Frontend:
- Update the station queue screen and ward/bed dashboard to prefer the WebSocket
  stream, falling back to polling.

Verify: open two station screens simultaneously, transition a visit on one, and confirm
the other updates without a manual refresh.
```

---

## 13. Hardening & Pilot Readiness

```
Prepare the system for pilot go-live.

- Add `restart: unless-stopped` to all docker-compose services if not already set, and
  verify MySQL is configured with crash-safe InnoDB settings (proper flush/journaling)
  to survive abrupt power loss.
- Add an automated nightly backup job (mysqldump to a local/external path, gzip +
  timestamp the file) runnable via a cron-like container or host cron calling into
  the mysql container.
- Write a basic seed/import script for migrating an existing paper patient list into
  the Patients table ahead of go-live (CSV import with duplicate-check reuse from
  module 4).
- Do a review pass across all P0 endpoints confirming: DB transactions are used
  everywhere money/bed-state changes, every write has server-side validation (not just
  client-side), and Audit_Logs are populated for clinical/billing/admission changes.
- Produce a one-page "Find a Patient / Recover a Lost ID" quick-reference doc (plain
  text is fine) for reception staff training.

This is the final module before pilot handoff — treat it as a checklist pass over
everything built in modules 1–12, not new feature work.
```
