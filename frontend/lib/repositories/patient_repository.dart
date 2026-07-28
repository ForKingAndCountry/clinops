import '../models/patient.dart';
import '../models/visit.dart';

abstract class PatientRepository {
  // Search patients by multiple paths (ID, name, phone, DOB+community)
  Future<List<Patient>> search(String query);
  
  // Register a new patient
  Future<Patient> register(Patient patient);
  
  // Get patient by hospital ID
  Future<Patient?> getByHospitalId(String hospitalId);
  
  // Get patient by ID
  Future<Patient?> getById(int id);
  
  // Get full patient chart (patient + visit history)
  Future<Map<String, dynamic>> getChart(int patientId);
  
  // Check for potential duplicates
  Future<List<Patient>> checkDuplicates(Patient patient);
  
  // Update patient information
  Future<Patient> update(Patient patient);
}

abstract class VisitRepository {
  // Get visits by patient ID
  Future<List<Visit>> getPatientVisits(int patientId);
  
  // Create a new visit
  Future<Visit> createVisit(Visit visit);
  
  // Transition visit to next state
  Future<Visit> transition(int visitId, VisitStatus toState);
  
  // Get current active visit for a patient
  Future<Visit?> getActiveVisit(int patientId);
  
  // Get queue for a specific station
  Future<List<Visit>> getQueue(VisitStatus station);
  
  // Stream for live queue updates
  Stream<List<Visit>> watchQueue(VisitStatus station);
  
  // Get visit by ID
  Future<Visit?> getById(int id);
  
  // Get visit transitions history
  Future<List<VisitTransition>> getTransitions(int visitId);
}
