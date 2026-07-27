# Database Schema Diagram

## Core Tables Overview

### Patient Management
- **patients** - Patient records with multi-path search support (hospital_id, normalized_name, phone, dob, community)
- **visits** - OPD/IPD visits with status tracking (RECEPTION → VITALS → DOCTOR → LAB → PHARMACY → BILLING → DISCHARGED)
- **visit_transitions** - Audit trail of visit state changes

### Clinical Workflows
- **encounters** - Doctor consultations with clinical notes
- **diagnoses_catalog** - Coded diagnosis list (ICD-10 or local codes)
- **encounter_diagnoses** - Link table between encounters and diagnoses (to be added in implementation)

### Laboratory
- **lab_test_catalog** - Available lab tests with result types and normal ranges
- **lab_orders** - Lab test orders linked to visits/encounters
- **lab_results** - Structured lab results with abnormal flag

### Pharmacy
- **drug_formulary** - Drug inventory with stock tracking
- **prescriptions** - Prescription headers linked to visits/encounters
- **prescription_items** - Structured prescription details (drug, dose, route, frequency, duration) - NO free-text instructions as primary data

### Billing
- **billing_items** - Billable items (consultation, lab, drugs, procedures, bed charges)
- **payments** - Payment records with method tracking

### Inpatient (IPD)
- **wards** - Ward definitions with capacity
- **beds** - Bed inventory with status (free/occupied/maintenance) and current admission FK
- **admissions** - Patient admissions with bed assignment (requires transaction + row lock in Service layer)
- **nursing_notes** - Ward nursing documentation
- **vitals_records** - Vitals charting for both OPD and IPD

### Administration
- **users** - User profiles (CodeIgniter Shield handles auth/RBAC)
- **audit_logs** - Comprehensive audit trail (table_name, record_id, action, actor, before/after JSON)

### Referrals
- **referrals** - External facility referrals

## Key Relationships

```
patients (1) ────────< (N) visits
visits (1) ────────< (N) visit_transitions
visits (1) ────────< (N) encounters
visits (1) ────────< (N) lab_orders
visits (1) ────────< (N) prescriptions
visits (1) ────────< (N) billing_items
visits (1) ────────< (N) payments
visits (1) ────────< (N) vitals_records
visits (1) ────────< (N) referrals

encounters (1) ────────< (N) lab_orders
encounters (1) ────────< (N) prescriptions

lab_test_catalog (1) ────────< (N) lab_orders
lab_orders (1) ────────< (1) lab_results

drug_formulary (1) ────────< (N) prescription_items
prescriptions (1) ────────< (N) prescription_items

wards (1) ────────< (N) beds
beds (1) ────────< (1) admissions (current_admission_id)
admissions (1) ────────< (N) nursing_notes
admissions (1) ────────< (N) vitals_records

patients (1) ────────< (N) admissions
```

## Important Schema Notes

### Multi-Path Patient Search
- `patients.hospital_id` - Unique, human-friendly generated ID
- `patients.normalized_name` - Lowercase, trimmed for fuzzy matching
- Indexed columns: `normalized_name`, `phone`, `date_of_birth`, `community`

### Structured Clinical Orders
- `prescription_items` has NO free-text "instructions" field as primary data
- Structured fields: `drug_id`, `dose`, `dose_unit`, `route`, `frequency`, `duration`
- Optional `notes` field exists for doctor reference only (not for pharmacy action)

### Bed Allocation Integrity
- `beds.status` enum: free/occupied/maintenance
- `beds.current_admission_id` FK when occupied
- **Service layer must enforce**: transaction + row lock to prevent double-booking
- Documented in migration comment on beds table

### Audit Trail
- `audit_logs` captures all create/update/delete operations
- Stores before/after state as JSON
- Tracks actor_user_id, IP address, user agent

### Soft Deletes
- Tables with clinical/business data include `deleted_at` for soft delete:
  - patients, visits, encounters, lab_orders, prescriptions, admissions, referrals

### Foreign Key Constraints
- Most relationships use CASCADE delete for referential integrity
- Some use SET NULL where the parent can be deleted independently
- RESTRICT used for critical relationships (patients, drugs, beds)
