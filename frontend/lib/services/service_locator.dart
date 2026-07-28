import 'package:get_it/get_it.dart';
import '../repositories/patient_repository.dart';
import '../repositories/clinical_repository.dart';
import '../repositories/prescription_repository.dart';
import '../repositories/billing_repository.dart';
import '../repositories/admission_repository.dart';
import '../repositories/lab_repository.dart';
import '../repositories/report_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/mock/mock_patient_repository.dart';
import '../repositories/mock/mock_visit_repository.dart';
import '../repositories/mock/mock_clinical_repository.dart';
import '../repositories/mock/mock_prescription_repository.dart';
import '../repositories/mock/mock_billing_repository.dart';
import '../repositories/mock/mock_admission_repository.dart';
import '../repositories/mock/mock_lab_repository.dart';
import '../repositories/mock/mock_report_repository.dart';
import '../repositories/mock/mock_auth_repository.dart';

// GetIt service locator instance
final getIt = GetIt.instance;

/// Initialize service locator with mock implementations
/// 
/// IMPORTANT: To swap from mock to real backend implementations later:
/// 1. Implement RealXRepository classes that call actual API endpoints
/// 2. Replace the registerLazySingleton calls below with real implementations
/// 3. Screens and widgets should never need to change - they depend on interfaces only
void setupServiceLocator() {
  // Register mock auth repository
  getIt.registerLazySingleton<AuthRepository>(
    () => MockAuthRepository(),
  );

  // Register mock patient repository
  getIt.registerLazySingleton<PatientRepository>(
    () => MockPatientRepository(),
  );

  // Register mock visit repository (depends on patient repository)
  getIt.registerLazySingleton<VisitRepository>(
    () => MockVisitRepository(getIt<PatientRepository>() as MockPatientRepository),
  );

  // Register mock clinical repository
  getIt.registerLazySingleton<ClinicalRepository>(
    () => MockClinicalRepository(),
  );

  // Register mock prescription repository
  getIt.registerLazySingleton<PrescriptionRepository>(
    () => MockPrescriptionRepository(),
  );

  // Register mock billing repository
  getIt.registerLazySingleton<BillingRepository>(
    () => MockBillingRepository(),
  );

  // Register mock admission repository
  getIt.registerLazySingleton<AdmissionRepository>(
    () => MockAdmissionRepository(),
  );

  // Register mock ward repository
  getIt.registerLazySingleton<WardRepository>(
    () => MockWardRepository(),
  );

  // Register mock vitals repository
  getIt.registerLazySingleton<VitalsRepository>(
    () => MockVitalsRepository(),
  );

  // Register mock nursing repository
  getIt.registerLazySingleton<NursingRepository>(
    () => MockNursingRepository(),
  );

  // Register mock lab repository
  getIt.registerLazySingleton<LabRepository>(
    () => MockLabRepository(),
  );

  // Register mock report repository
  getIt.registerLazySingleton<ReportRepository>(
    () => MockReportRepository(),
  );
}

/// Reset service locator (useful for testing or demo reset)
void resetServiceLocator() {
  getIt.reset();
  setupServiceLocator();
}

/// Enable/disable error simulation for all mock repositories
/// This is useful for testing loading and error states in the UI
void setSimulateErrors(bool simulate) {
  final authRepo = getIt<AuthRepository>() as MockAuthRepository;
  authRepo.setSimulateErrors(simulate);

  final patientRepo = getIt<PatientRepository>() as MockPatientRepository;
  patientRepo.setSimulateErrors(simulate);

  final visitRepo = getIt<VisitRepository>() as MockVisitRepository;
  visitRepo.setSimulateErrors(simulate);

  final clinicalRepo = getIt<ClinicalRepository>() as MockClinicalRepository;
  clinicalRepo.setSimulateErrors(simulate);

  final prescriptionRepo = getIt<PrescriptionRepository>() as MockPrescriptionRepository;
  prescriptionRepo.setSimulateErrors(simulate);

  final billingRepo = getIt<BillingRepository>() as MockBillingRepository;
  billingRepo.setSimulateErrors(simulate);

  final admissionRepo = getIt<AdmissionRepository>() as MockAdmissionRepository;
  admissionRepo.setSimulateErrors(simulate);

  final wardRepo = getIt<WardRepository>() as MockWardRepository;
  wardRepo.setSimulateErrors(simulate);

  final vitalsRepo = getIt<VitalsRepository>() as MockVitalsRepository;
  vitalsRepo.setSimulateErrors(simulate);

  final nursingRepo = getIt<NursingRepository>() as MockNursingRepository;
  nursingRepo.setSimulateErrors(simulate);

  final labRepo = getIt<LabRepository>() as MockLabRepository;
  labRepo.setSimulateErrors(simulate);
}

/// Reset all mock data to initial seed state
/// This is useful for demo repeatability
void resetMockData() {
  final patientRepo = getIt<PatientRepository>() as MockPatientRepository;
  patientRepo.resetData();

  final visitRepo = getIt<VisitRepository>() as MockVisitRepository;
  visitRepo.resetData();

  final clinicalRepo = getIt<ClinicalRepository>() as MockClinicalRepository;
  clinicalRepo.resetData();

  final prescriptionRepo = getIt<PrescriptionRepository>() as MockPrescriptionRepository;
  prescriptionRepo.resetData();

  final billingRepo = getIt<BillingRepository>() as MockBillingRepository;
  billingRepo.resetData();

  final admissionRepo = getIt<AdmissionRepository>() as MockAdmissionRepository;
  admissionRepo.resetData();

  final wardRepo = getIt<WardRepository>() as MockWardRepository;
  wardRepo.resetData();

  final vitalsRepo = getIt<VitalsRepository>() as MockVitalsRepository;
  vitalsRepo.resetData();

  final nursingRepo = getIt<NursingRepository>() as MockNursingRepository;
  nursingRepo.resetData();

  final labRepo = getIt<LabRepository>() as MockLabRepository;
  labRepo.resetData();
}
