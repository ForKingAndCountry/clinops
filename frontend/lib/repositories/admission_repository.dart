import '../models/admission.dart';
import '../models/vitals_record.dart';
import '../models/nursing_note.dart';

abstract class AdmissionRepository {
  // Create admission
  Future<Admission> admit(Admission admission);
  
  // Get admission by ID
  Future<Admission?> getById(int id);
  
  // Get active admission for patient
  Future<Admission?> getActiveAdmission(int patientId);
  
  // Discharge patient
  Future<Admission> discharge(int admissionId, String reason);
  
  // Get all active admissions
  Future<List<Admission>> getActiveAdmissions();
  
  // Assign bed to admission
  Future<Admission> assignBed(int admissionId, int bedId);
  
  // Get admissions by ward
  Future<List<Admission>> getWardAdmissions(int wardId);
}

abstract class WardRepository {
  // Get all wards
  Future<List<Ward>> getWards();
  
  // Get ward by ID
  Future<Ward?> getById(int id);
  
  // Get beds for a ward
  Future<List<Bed>> getWardBeds(int wardId);
  
  // Get available beds
  Future<List<Bed>> getAvailableBeds();
  
  // Update bed status
  Future<Bed> updateBedStatus(int bedId, BedStatus status);
  
  // Stream for bed status updates
  Stream<List<Bed>> watchWardBeds(int wardId);
}

abstract class VitalsRepository {
  // Record vitals for visit
  Future<VitalsRecord> recordVisitVitals(VitalsRecord vitals);
  
  // Record vitals for admission
  Future<VitalsRecord> recordAdmissionVitals(VitalsRecord vitals);
  
  // Get vitals for visit
  Future<List<VitalsRecord>> getVisitVitals(int visitId);
  
  // Get vitals for admission
  Future<List<VitalsRecord>> getAdmissionVitals(int admissionId);
  
  // Get latest vitals for admission
  Future<VitalsRecord?> getLatestAdmissionVitals(int admissionId);
}

abstract class NursingRepository {
  // Add nursing note
  Future<NursingNote> addNote(NursingNote note);
  
  // Get nursing notes for admission
  Future<List<NursingNote>> getAdmissionNotes(int admissionId);
  
  // Get recent notes for admission
  Future<List<NursingNote>> getRecentNotes(int admissionId, int limit);
}
