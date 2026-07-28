import 'dart:async';
import 'dart:math';
import '../clinical_repository.dart';
import '../../models/encounter.dart';
import '../../models/diagnosis.dart';

class MockClinicalRepository implements ClinicalRepository {
  final Map<int, Encounter> _encounters = {};
  final Map<int, List<EncounterDiagnosis>> _encounterDiagnoses = {};
  final Map<int, DiagnosisCatalog> _diagnosisCatalog = {};
  int _nextEncounterId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockClinicalRepository() {
    _seedDiagnosisCatalog();
  }

  void _seedDiagnosisCatalog() {
    final now = DateTime.now();
    
    // BPHS-relevant diagnosis catalog
    final diagnoses = [
      DiagnosisCatalog(
        id: 1,
        code: 'A00',
        name: 'Cholera',
        description: 'Acute diarrheal infection caused by ingestion of contaminated water or food',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 2,
        code: 'A01',
        name: 'Typhoid Fever',
        description: 'Bacterial infection caused by Salmonella Typhi',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 3,
        code: 'A02',
        name: 'Other Salmonella infections',
        description: 'Gastroenteritis and other Salmonella infections',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 4,
        code: 'A03',
        name: 'Shigellosis',
        description: 'Bacterial dysentery caused by Shigella',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 5,
        code: 'A09',
        name: 'Gastroenteritis',
        description: 'Inflammation of the stomach and intestines',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 6,
        code: 'J00',
        name: 'Acute nasopharyngitis (common cold)',
        description: 'Viral infection of upper respiratory tract',
        category: 'Respiratory',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 7,
        code: 'J01',
        name: 'Acute sinusitis',
        description: 'Inflammation of sinuses',
        category: 'Respiratory',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 8,
        code: 'J02',
        name: 'Acute pharyngitis',
        description: 'Sore throat infection',
        category: 'Respiratory',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 9,
        code: 'J18',
        name: 'Pneumonia',
        description: 'Infection of lungs',
        category: 'Respiratory',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 10,
        code: 'J45',
        name: 'Asthma',
        description: 'Chronic inflammatory disease of airways',
        category: 'Chronic',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 11,
        code: 'I10',
        name: 'Essential hypertension',
        description: 'High blood pressure without known cause',
        category: 'Chronic',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 12,
        code: 'I50',
        name: 'Heart failure',
        description: 'Inability of heart to pump sufficient blood',
        category: 'Chronic',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 13,
        code: 'E11',
        name: 'Type 2 diabetes mellitus',
        description: 'Chronic metabolic disorder',
        category: 'Chronic',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 14,
        code: 'E40',
        name: 'Protein-energy malnutrition',
        description: 'Severe malnutrition',
        category: 'Nutritional',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 15,
        code: 'E41',
        name: 'Marasmus',
        description: 'Severe protein-energy deficiency',
        category: 'Nutritional',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 16,
        code: 'E42',
        name: 'Kwashiorkor',
        description: 'Protein deficiency with edema',
        category: 'Nutritional',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 17,
        code: 'B01',
        name: 'Varicella (Chickenpox)',
        description: 'Viral infection causing itchy rash',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 18,
        code: 'B26',
        name: 'Mumps',
        description: 'Viral infection of salivary glands',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 19,
        code: 'B34',
        name: 'Measles',
        description: 'Highly contagious viral infection',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 20,
        code: 'A50',
        name: 'Congenital syphilis',
        description: 'Syphilis transmitted from mother to child',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 21,
        code: 'B60',
        name: 'Malaria',
        description: 'Mosquito-borne parasitic disease',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 22,
        code: 'A60',
        name: 'Anogenital herpes',
        description: 'Herpes simplex virus infection',
        category: 'Infectious',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 23,
        code: 'O00',
        name: 'Ectopic pregnancy',
        description: 'Pregnancy outside uterus',
        category: 'Obstetric',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 24,
        code: 'O80',
        name: 'Normal delivery',
        description: 'Spontaneous vaginal delivery',
        category: 'Obstetric',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 25,
        code: 'P00',
        name: 'Newborn affected by maternal conditions',
        description: 'Newborn complications from maternal factors',
        category: 'Pediatric',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 26,
        code: 'P22',
        name: 'Respiratory distress of newborn',
        description: 'Breathing difficulties in newborn',
        category: 'Pediatric',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 27,
        code: 'N00',
        name: 'Acute nephritic syndrome',
        description: 'Kidney inflammation',
        category: 'Renal',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 28,
        code: 'K35',
        name: 'Acute appendicitis',
        description: 'Inflammation of appendix',
        category: 'Surgical',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 29,
        code: 'S00',
        name: 'Superficial injury of head',
        description: 'Minor head injuries, cuts, bruises',
        category: 'Trauma',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      DiagnosisCatalog(
        id: 30,
        code: 'T20',
        name: 'Burn of head and neck',
        description: 'Thermal burns to head/neck area',
        category: 'Trauma',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (var diagnosis in diagnoses) {
      _diagnosisCatalog[diagnosis.id!] = diagnosis;
    }
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
  Future<Encounter> createEncounter(Encounter encounter) async {
    await _simulateDelay();
    _maybeThrowError();

    final newEncounter = encounter.copyWith(
      id: _nextEncounterId++,
      encounterTime: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _encounters[newEncounter.id!] = newEncounter;
    return newEncounter;
  }

  @override
  Future<List<Encounter>> getVisitEncounters(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _encounters.values.where((e) => e.visitId == visitId).toList();
  }

  @override
  Future<Encounter?> getById(int id) async {
    await _simulateDelay();
    _maybeThrowError();

    return _encounters[id];
  }

  @override
  Future<Encounter> update(Encounter encounter) async {
    await _simulateDelay();
    _maybeThrowError();

    if (encounter.id == null || !_encounters.containsKey(encounter.id)) {
      throw Exception('Encounter not found');
    }

    final updatedEncounter = encounter.copyWith(
      updatedAt: DateTime.now(),
    );

    _encounters[encounter.id!] = updatedEncounter;
    return updatedEncounter;
  }

  @override
  Future<EncounterDiagnosis> addDiagnosis(EncounterDiagnosis encounterDiagnosis) async {
    await _simulateDelay();
    _maybeThrowError();

    final newDiagnosis = EncounterDiagnosis(
      id: _encounterDiagnoses.length + 1,
      encounterId: encounterDiagnosis.encounterId,
      diagnosisId: encounterDiagnosis.diagnosisId,
      isPrimary: encounterDiagnosis.isPrimary,
      createdAt: DateTime.now(),
    );

    if (!_encounterDiagnoses.containsKey(newDiagnosis.encounterId)) {
      _encounterDiagnoses[newDiagnosis.encounterId] = [];
    }
    _encounterDiagnoses[newDiagnosis.encounterId]!.add(newDiagnosis);
    
    return newDiagnosis;
  }

  @override
  Future<List<EncounterDiagnosis>> getEncounterDiagnoses(int encounterId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _encounterDiagnoses[encounterId] ?? [];
  }

  @override
  Future<List<DiagnosisCatalog>> getDiagnosisCatalog() async {
    await _simulateDelay();
    _maybeThrowError();

    return _diagnosisCatalog.values.toList();
  }

  @override
  Future<List<DiagnosisCatalog>> searchDiagnoses(String query) async {
    await _simulateDelay();
    _maybeThrowError();

    final normalizedQuery = query.toLowerCase().trim();
    
    if (normalizedQuery.isEmpty) {
      return _diagnosisCatalog.values.toList();
    }

    return _diagnosisCatalog.values.where((d) {
      return d.name.toLowerCase().contains(normalizedQuery) ||
             d.code.toLowerCase().contains(normalizedQuery) ||
             d.category.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  // Reset data to initial state
  void resetData() {
    _encounters.clear();
    _encounterDiagnoses.clear();
    _nextEncounterId = 1;
  }

  // Helper to get diagnosis by ID
  DiagnosisCatalog? getDiagnosisById(int id) {
    return _diagnosisCatalog[id];
  }
}
