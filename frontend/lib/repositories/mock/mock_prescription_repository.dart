import 'dart:async';
import 'dart:math';
import '../prescription_repository.dart';
import '../../models/pharmacy.dart';

class MockPrescriptionRepository implements PrescriptionRepository {
  final Map<int, Prescription> _prescriptions = {};
  final Map<int, List<PrescriptionItem>> _prescriptionItems = {};
  final Map<int, DrugFormularyItem> _drugFormulary = {};
  final Map<int, List<String>> _patientAllergies = {}; // Mock allergy tracking
  int _nextPrescriptionId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockPrescriptionRepository() {
    _seedDrugFormulary();
    _seedPatientAllergies();
  }

  void _seedDrugFormulary() {
    final now = DateTime.now();
    
    // Common BPHS-relevant drugs
    final drugs = [
      DrugFormularyItem(
        id: 1,
        name: 'Paracetamol',
        genericName: 'Acetaminophen',
        manufacturer: 'Local Pharma',
        strength: '500',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 500,
        minStockLevel: 50,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 2,
        name: 'Amoxicillin',
        genericName: 'Amoxicillin trihydrate',
        manufacturer: 'Global Meds',
        strength: '250',
        unit: 'mg',
        form: 'capsule',
        stockQuantity: 200,
        minStockLevel: 30,
        storageRequirements: 'Store in cool, dry place',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 3,
        name: 'Artemether/Lumefantrine',
        genericName: 'Artemether/Lumefantrine',
        manufacturer: 'Malaria Control',
        strength: '20/120',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 150,
        minStockLevel: 25,
        storageRequirements: 'Protect from light',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 4,
        name: 'Ibuprofen',
        genericName: 'Ibuprofen',
        manufacturer: 'Pain Relief Co',
        strength: '400',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 300,
        minStockLevel: 40,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 5,
        name: 'Ciprofloxacin',
        genericName: 'Ciprofloxacin hydrochloride',
        manufacturer: 'Antibiotic Ltd',
        strength: '500',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 100,
        minStockLevel: 20,
        storageRequirements: 'Store in cool, dry place',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 6,
        name: 'Metronidazole',
        genericName: 'Metronidazole',
        manufacturer: 'Infection Control',
        strength: '400',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 250,
        minStockLevel: 30,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 7,
        name: 'Oral Rehydration Salts',
        genericName: 'ORS',
        manufacturer: 'WHO Approved',
        strength: '20.5',
        unit: 'g',
        form: 'sachet',
        stockQuantity: 1000,
        minStockLevel: 100,
        storageRequirements: 'Store in dry place',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 8,
        name: 'Zinc Sulfate',
        genericName: 'Zinc sulfate',
        manufacturer: 'Mineral Supplements',
        strength: '20',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 400,
        minStockLevel: 50,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 9,
        name: 'Vitamin A',
        genericName: 'Retinol',
        manufacturer: 'Nutrition Plus',
        strength: '200000',
        unit: 'IU',
        form: 'capsule',
        stockQuantity: 200,
        minStockLevel: 30,
        storageRequirements: 'Protect from light',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 10,
        name: 'Iron Folate',
        genericName: 'Ferrous sulfate + Folic acid',
        manufacturer: 'Anemia Control',
        strength: '60+0.4',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 300,
        minStockLevel: 40,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 11,
        name: 'Diazepam',
        genericName: 'Diazepam',
        manufacturer: 'Calm Pharma',
        strength: '5',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 50,
        minStockLevel: 10,
        storageRequirements: 'Store securely, controlled substance',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 12,
        name: 'Salbutamol',
        genericName: 'Albuterol sulfate',
        manufacturer: 'Respiratory Care',
        strength: '100',
        unit: 'mcg',
        form: 'inhaler',
        stockQuantity: 80,
        minStockLevel: 15,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 13,
        name: 'Hydrochlorothiazide',
        genericName: 'Hydrochlorothiazide',
        manufacturer: 'BP Control',
        strength: '25',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 150,
        minStockLevel: 25,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 14,
        name: 'Enalapril',
        genericName: 'Enalapril maleate',
        manufacturer: 'Cardio Health',
        strength: '10',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 120,
        minStockLevel: 20,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 15,
        name: 'Metformin',
        genericName: 'Metformin hydrochloride',
        manufacturer: 'Diabetes Care',
        strength: '500',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 200,
        minStockLevel: 30,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 16,
        name: 'Glibenclamide',
        genericName: 'Glyburide',
        manufacturer: 'Diabetes Care',
        strength: '5',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 100,
        minStockLevel: 20,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 17,
        name: 'Omeprazole',
        genericName: 'Omeprazole',
        manufacturer: 'Gastric Relief',
        strength: '20',
        unit: 'mg',
        form: 'capsule',
        stockQuantity: 180,
        minStockLevel: 25,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 18,
        name: 'Ranitidine',
        genericName: 'Ranitidine hydrochloride',
        manufacturer: 'Gastric Relief',
        strength: '150',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 150,
        minStockLevel: 25,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 19,
        name: 'Ceftriaxone',
        genericName: 'Ceftriaxone sodium',
        manufacturer: 'Antibiotic Ltd',
        strength: '1',
        unit: 'g',
        form: 'injection',
        stockQuantity: 40,
        minStockLevel: 10,
        storageRequirements: 'Refrigerate 2-8°C',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 20,
        name: 'Gentamicin',
        genericName: 'Gentamicin sulfate',
        manufacturer: 'Antibiotic Ltd',
        strength: '80',
        unit: 'mg',
        form: 'injection',
        stockQuantity: 60,
        minStockLevel: 15,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 21,
        name: 'Diazepam injection',
        genericName: 'Diazepam',
        manufacturer: 'Calm Pharma',
        strength: '10',
        unit: 'mg',
        form: 'injection',
        stockQuantity: 30,
        minStockLevel: 10,
        storageRequirements: 'Store securely, controlled substance',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 22,
        name: 'Phenobarbital',
        genericName: 'Phenobarbital',
        manufacturer: 'Neuro Care',
        strength: '100',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 40,
        minStockLevel: 10,
        storageRequirements: 'Store securely, controlled substance',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 23,
        name: 'Furosemide',
        genericName: 'Furosemide',
        manufacturer: 'Diuretic Plus',
        strength: '40',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 100,
        minStockLevel: 20,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 24,
        name: 'Spironolactone',
        genericName: 'Spironolactone',
        manufacturer: 'Diuretic Plus',
        strength: '25',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 80,
        minStockLevel: 15,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DrugFormularyItem(
        id: 25,
        name: 'Digoxin',
        genericName: 'Digoxin',
        manufacturer: 'Cardio Health',
        strength: '0.25',
        unit: 'mg',
        form: 'tablet',
        stockQuantity: 50,
        minStockLevel: 10,
        storageRequirements: 'Store at room temperature',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      // Deliberately low stock item for demo
      DrugFormularyItem(
        id: 26,
        name: 'Insulin (regular)',
        genericName: 'Human insulin',
        manufacturer: 'Diabetes Care',
        strength: '100',
        unit: 'IU/ml',
        form: 'injection',
        stockQuantity: 5,
        minStockLevel: 20,
        storageRequirements: 'Refrigerate 2-8°C',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (var drug in drugs) {
      _drugFormulary[drug.id!] = drug;
    }
  }

  void _seedPatientAllergies() {
    // Seed some patient allergies for safety check demo
    _patientAllergies[1] = ['Penicillin']; // Kofi Johnson
    _patientAllergies[3] = ['Aspirin']; // James Weah
    _patientAllergies[5] = ['Sulfa drugs']; // Boakai Sesay
    _patientAllergies[12] = ['Codeine']; // Grace Taylor
    _patientAllergies[17] = ['Penicillin', 'Sulfa']; // Joseph Brown
  }

  Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(500);
    await Future.delayed(Duration(milliseconds: delay));
  }

  void _maybeThrowError() {
    if (_simulateErrors && _random.nextDouble() < 0.1) {
      throw Exception('Simulated network error');
    }
  }

  void setSimulateErrors(bool simulate) {
    _simulateErrors = simulate;
  }

  @override
  Future<Prescription> createPrescription(Prescription prescription) async {
    await _simulateDelay();
    _maybeThrowError();

    final newPrescription = prescription.copyWith(
      id: _nextPrescriptionId++,
      prescribedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _prescriptions[newPrescription.id!] = newPrescription;
    return newPrescription;
  }

  @override
  Future<PrescriptionItem> addItem(PrescriptionItem item) async {
    await _simulateDelay();
    _maybeThrowError();

    final newItem = PrescriptionItem(
      id: _prescriptionItems.length + 1,
      prescriptionId: item.prescriptionId,
      drugId: item.drugId,
      dose: item.dose,
      doseUnit: item.doseUnit,
      route: item.route,
      frequency: item.frequency,
      duration: item.duration,
      notes: item.notes,
      isDispensed: false,
      dispensedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (!_prescriptionItems.containsKey(newItem.prescriptionId)) {
      _prescriptionItems[newItem.prescriptionId] = [];
    }
    _prescriptionItems[newItem.prescriptionId]!.add(newItem);
    
    return newItem;
  }

  @override
  Future<List<Prescription>> getVisitPrescriptions(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _prescriptions.values.where((p) => p.visitId == visitId).toList();
  }

  @override
  Future<List<PrescriptionItem>> getPrescriptionItems(int prescriptionId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _prescriptionItems[prescriptionId] ?? [];
  }

  @override
  Future<List<String>> checkSafety(int patientId, List<int> drugIds) async {
    await _simulateDelay();
    _maybeThrowError();

    final warnings = <String>[];
    final patientAllergies = _patientAllergies[patientId] ?? [];

    for (var drugId in drugIds) {
      final drug = _drugFormulary[drugId];
      if (drug == null) continue;

      // Check for allergies
      for (var allergy in patientAllergies) {
        if (drug.name.toLowerCase().contains(allergy.toLowerCase()) ||
            drug.genericName.toLowerCase().contains(allergy.toLowerCase())) {
          warnings.add('ALLERGY WARNING: Patient is allergic to $allergy. Drug ${drug.name} may contain $allergy.');
        }
      }

      // Check for drug interactions (simplified mock)
      if (drug.name.contains('Warfarin') && drugIds.any((id) => _drugFormulary[id]?.name.contains('Aspirin') ?? false)) {
        warnings.add('INTERACTION WARNING: Warfarin and Aspirin interaction - increased bleeding risk.');
      }
    }

    return warnings;
  }

  @override
  Future<PrescriptionItem> dispenseItem(int itemId, int quantity) async {
    await _simulateDelay();
    _maybeThrowError();

    // Find the item
    PrescriptionItem? targetItem;
    int? prescriptionId;
    
    for (var entry in _prescriptionItems.entries) {
      final item = entry.value.firstWhere((i) => i.id == itemId, orElse: () => targetItem!);
      if (item.id == itemId) {
        targetItem = item;
        prescriptionId = entry.key;
        break;
      }
    }

    if (targetItem == null) {
      throw Exception('Prescription item not found');
    }

    // Update drug stock
    final drug = _drugFormulary[targetItem.drugId];
    if (drug == null) {
      throw Exception('Drug not found');
    }

    if (drug.stockQuantity < quantity) {
      throw Exception('Insufficient stock');
    }

    _drugFormulary[targetItem.drugId] = drug.copyWith(
      stockQuantity: drug.stockQuantity - quantity,
      updatedAt: DateTime.now(),
    );

    // Mark as dispensed
    final updatedItem = targetItem.copyWith(
      isDispensed: true,
      dispensedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Update in the list
    if (prescriptionId != null) {
      final index = _prescriptionItems[prescriptionId]!.indexWhere((i) => i.id == itemId);
      _prescriptionItems[prescriptionId]![index] = updatedItem;
    }

    return updatedItem;
  }

  @override
  Future<List<DrugFormularyItem>> getDrugFormulary() async {
    await _simulateDelay();
    _maybeThrowError();

    return _drugFormulary.values.toList();
  }

  @override
  Future<List<DrugFormularyItem>> searchDrugs(String query) async {
    await _simulateDelay();
    _maybeThrowError();

    final normalizedQuery = query.toLowerCase().trim();
    
    if (normalizedQuery.isEmpty) {
      return _drugFormulary.values.toList();
    }

    return _drugFormulary.values.where((d) {
      return d.name.toLowerCase().contains(normalizedQuery) ||
             d.genericName.toLowerCase().contains(normalizedQuery) ||
             d.form.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  @override
  Future<DrugFormularyItem> updateStock(int drugId, int quantityChange) async {
    await _simulateDelay();
    _maybeThrowError();

    final drug = _drugFormulary[drugId];
    if (drug == null) {
      throw Exception('Drug not found');
    }

    final newQuantity = drug.stockQuantity + quantityChange;
    if (newQuantity < 0) {
      throw Exception('Stock cannot be negative');
    }

    final updatedDrug = drug.copyWith(
      stockQuantity: newQuantity,
      updatedAt: DateTime.now(),
    );

    _drugFormulary[drugId] = updatedDrug;
    return updatedDrug;
  }

  @override
  Future<List<PrescriptionItem>> getPendingDispensing() async {
    await _simulateDelay();
    _maybeThrowError();

    final pendingItems = <PrescriptionItem>[];
    
    for (var items in _prescriptionItems.values) {
      pendingItems.addAll(items.where((i) => !i.isDispensed));
    }
    
    return pendingItems;
  }

  // Reset data to initial state
  void resetData() {
    _prescriptions.clear();
    _prescriptionItems.clear();
    _nextPrescriptionId = 1;
    _seedDrugFormulary();
    _seedPatientAllergies();
  }

  // Helper to get drug by ID
  DrugFormularyItem? getDrugById(int id) {
    return _drugFormulary[id];
  }
}
