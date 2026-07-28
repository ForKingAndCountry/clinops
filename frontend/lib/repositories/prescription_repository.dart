import '../models/pharmacy.dart';

abstract class PrescriptionRepository {
  // Create a prescription
  Future<Prescription> createPrescription(Prescription prescription);
  
  // Add item to prescription
  Future<PrescriptionItem> addItem(PrescriptionItem item);
  
  // Get prescriptions by visit ID
  Future<List<Prescription>> getVisitPrescriptions(int visitId);
  
  // Get prescription items
  Future<List<PrescriptionItem>> getPrescriptionItems(int prescriptionId);
  
  // Check for drug interactions/allergies
  Future<List<String>> checkSafety(int patientId, List<int> drugIds);
  
  // Mark item as dispensed
  Future<PrescriptionItem> dispenseItem(int itemId, int quantity);
  
  // Get drug formulary
  Future<List<DrugFormularyItem>> getDrugFormulary();
  
  // Search drug formulary
  Future<List<DrugFormularyItem>> searchDrugs(String query);
  
  // Update drug stock
  Future<DrugFormularyItem> updateStock(int drugId, int quantityChange);
  
  // Get pending prescriptions for dispensing
  Future<List<PrescriptionItem>> getPendingDispensing();
}
