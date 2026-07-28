import '../models/encounter.dart';
import '../models/diagnosis.dart';

abstract class ClinicalRepository {
  // Create a doctor encounter
  Future<Encounter> createEncounter(Encounter encounter);
  
  // Get encounters by visit ID
  Future<List<Encounter>> getVisitEncounters(int visitId);
  
  // Get encounter by ID
  Future<Encounter?> getById(int id);
  
  // Update encounter
  Future<Encounter> update(Encounter encounter);
  
  // Add diagnosis to encounter
  Future<EncounterDiagnosis> addDiagnosis(EncounterDiagnosis encounterDiagnosis);
  
  // Get diagnoses for an encounter
  Future<List<EncounterDiagnosis>> getEncounterDiagnoses(int encounterId);
  
  // Get diagnosis catalog
  Future<List<DiagnosisCatalog>> getDiagnosisCatalog();
  
  // Search diagnosis catalog
  Future<List<DiagnosisCatalog>> searchDiagnoses(String query);
}
