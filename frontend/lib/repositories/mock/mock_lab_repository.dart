import 'dart:async';
import 'dart:math';
import '../lab_repository.dart';
import '../../models/lab.dart';

class MockLabRepository implements LabRepository {
  final Map<int, LabOrder> _labOrders = {};
  final Map<int, LabResult> _labResults = {};
  final Map<int, LabTestCatalog> _labTestCatalog = {};
  int _nextOrderId = 1;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockLabRepository() {
    _seedLabTestCatalog();
    _seedData();
  }

  void _seedLabTestCatalog() {
    final now = DateTime.now();
    
    // BPHS-relevant lab tests
    final labTests = [
      LabTestCatalog(
        id: 1,
        code: 'CBC',
        name: 'Complete Blood Count',
        category: 'Hematology',
        resultType: 'numeric',
        unit: 'cells/μL',
        normalRange: 'RBC: 4.5-5.5, WBC: 4.0-11.0, Platelets: 150-400',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 2,
        code: 'MALARIA',
        name: 'Malaria Parasite',
        category: 'Microbiology',
        resultType: 'text',
        unit: null,
        normalRange: 'Negative',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 3,
        code: 'WIDAL',
        name: 'Widal Test (Typhoid)',
        category: 'Microbiology',
        resultType: 'numeric',
        unit: 'titer',
        normalRange: '< 1:80',
        normalRangeLow: null,
        normalRangeHigh: '1:80',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 4,
        code: 'URINE',
        name: 'Urinalysis',
        category: 'Chemistry',
        resultType: 'text',
        unit: null,
        normalRange: 'Normal',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 5,
        code: 'GLUCOSE',
        name: 'Blood Glucose (Fasting)',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mg/dL',
        normalRange: '70-100',
        normalRangeLow: '70',
        normalRangeHigh: '100',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 6,
        code: 'GLUCOSE-R',
        name: 'Blood Glucose (Random)',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mg/dL',
        normalRange: '< 140',
        normalRangeLow: null,
        normalRangeHigh: '140',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 7,
        code: 'HGB',
        name: 'Hemoglobin',
        category: 'Hematology',
        resultType: 'numeric',
        unit: 'g/dL',
        normalRange: '12-16',
        normalRangeLow: '12',
        normalRangeHigh: '16',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 8,
        code: 'HCT',
        name: 'Hematocrit',
        category: 'Hematology',
        resultType: 'numeric',
        unit: '%',
        normalRange: '37-47',
        normalRangeLow: '37',
        normalRangeHigh: '47',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 9,
        code: 'HIV',
        name: 'HIV Rapid Test',
        category: 'Microbiology',
        resultType: 'text',
        unit: null,
        normalRange: 'Negative',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 10,
        code: 'VDRL',
        name: 'VDRL (Syphilis)',
        category: 'Microbiology',
        resultType: 'text',
        unit: null,
        normalRange: 'Non-reactive',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 11,
        code: 'HEPATITIS-B',
        name: 'Hepatitis B Surface Antigen',
        category: 'Microbiology',
        resultType: 'text',
        unit: null,
        normalRange: 'Negative',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 12,
        code: 'SICKLE',
        name: 'Sickle Cell Test',
        category: 'Hematology',
        resultType: 'text',
        unit: null,
        normalRange: 'Negative (AA)',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 13,
        code: 'BUN',
        name: 'Blood Urea Nitrogen',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mg/dL',
        normalRange: '7-20',
        normalRangeLow: '7',
        normalRangeHigh: '20',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 14,
        code: 'CREAT',
        name: 'Creatinine',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mg/dL',
        normalRange: '0.7-1.3',
        normalRangeLow: '0.7',
        normalRangeHigh: '1.3',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 15,
        code: 'SGOT',
        name: 'SGOT (AST)',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'U/L',
        normalRange: '10-40',
        normalRangeLow: '10',
        normalRangeHigh: '40',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 16,
        code: 'SGPT',
        name: 'SGPT (ALT)',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'U/L',
        normalRange: '7-56',
        normalRangeLow: '7',
        normalRangeHigh: '56',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 17,
        code: 'BILIRUBIN',
        name: 'Total Bilirubin',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mg/dL',
        normalRange: '0.3-1.2',
        normalRangeLow: '0.3',
        normalRangeHigh: '1.2',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 18,
        code: 'PROTEIN',
        name: 'Total Protein',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'g/dL',
        normalRange: '6.0-8.3',
        normalRangeLow: '6.0',
        normalRangeHigh: '8.3',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 19,
        code: 'ALBUMIN',
        name: 'Albumin',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'g/dL',
        normalRange: '3.5-5.0',
        normalRangeLow: '3.5',
        normalRangeHigh: '5.0',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 20,
        code: 'SODIUM',
        name: 'Sodium',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mmol/L',
        normalRange: '136-145',
        normalRangeLow: '136',
        normalRangeHigh: '145',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 21,
        code: 'POTASSIUM',
        name: 'Potassium',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mmol/L',
        normalRange: '3.5-5.1',
        normalRangeLow: '3.5',
        normalRangeHigh: '5.1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 22,
        code: 'CHLORIDE',
        name: 'Chloride',
        category: 'Chemistry',
        resultType: 'numeric',
        unit: 'mmol/L',
        normalRange: '98-107',
        normalRangeLow: '98',
        normalRangeHigh: '107',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 23,
        code: 'PT',
        name: 'Prothrombin Time',
        category: 'Hematology',
        resultType: 'numeric',
        unit: 'seconds',
        normalRange: '11-13',
        normalRangeLow: '11',
        normalRangeHigh: '13',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 24,
        code: 'APTT',
        name: 'Activated Partial Thromboplastin Time',
        category: 'Hematology',
        resultType: 'numeric',
        unit: 'seconds',
        normalRange: '25-35',
        normalRangeLow: '25',
        normalRangeHigh: '35',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      LabTestCatalog(
        id: 25,
        code: 'STOOL',
        name: 'Stool Analysis',
        category: 'Microbiology',
        resultType: 'text',
        unit: null,
        normalRange: 'Normal',
        normalRangeLow: null,
        normalRangeHigh: null,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (var test in labTests) {
      _labTestCatalog[test.id!] = test;
    }
  }

  void _seedData() {
    final now = DateTime.now();
    
    // Seed some lab orders for demo
    final seedOrders = [
      LabOrder(
        id: _nextOrderId++,
        visitId: 3,
        encounterId: null,
        labTestId: 2, // Malaria test
        orderedAt: now.subtract(const Duration(hours: 1)),
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      LabOrder(
        id: _nextOrderId++,
        visitId: 4,
        encounterId: null,
        labTestId: 1, // CBC
        orderedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
        createdAt: now.subtract(const Duration(hours: 1, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      LabOrder(
        id: _nextOrderId++,
        visitId: 6,
        encounterId: null,
        labTestId: 1, // CBC
        orderedAt: now.subtract(const Duration(hours: 2, minutes: 30)),
        createdAt: now.subtract(const Duration(hours: 2, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
    ];

    for (var order in seedOrders) {
      _labOrders[order.id!] = order;
    }

    // Seed some lab results
    final seedResults = [
      LabResult(
        id: 1,
        labOrderId: 1,
        result: 'Positive (+)',
        isAbnormal: true,
        notes: 'Plasmodium falciparum detected',
        technicianId: 1,
        resultTime: now.subtract(const Duration(minutes: 45)),
        createdAt: now.subtract(const Duration(minutes: 45)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
      ),
    ];

    for (var result in seedResults) {
      _labResults[result.labOrderId] = result;
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
  Future<LabOrder> orderTest(LabOrder order) async {
    await _simulateDelay();
    _maybeThrowError();

    final newOrder = LabOrder(
      id: _nextOrderId++,
      visitId: order.visitId,
      encounterId: order.encounterId,
      labTestId: order.labTestId,
      orderedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _labOrders[newOrder.id!] = newOrder;
    return newOrder;
  }

  @override
  Future<List<LabOrder>> getVisitOrders(int visitId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _labOrders.values.where((o) => o.visitId == visitId).toList();
  }

  @override
  Future<List<LabOrder>> getPendingOrders() async {
    await _simulateDelay();
    _maybeThrowError();

    final pendingOrders = <LabOrder>[];
    
    for (var order in _labOrders.values) {
      if (!_labResults.containsKey(order.id)) {
        pendingOrders.add(order);
      }
    }
    
    return pendingOrders;
  }

  @override
  Future<LabOrder?> getById(int id) async {
    await _simulateDelay();
    _maybeThrowError();

    return _labOrders[id];
  }

  @override
  Future<LabResult> submitResult(LabResult result) async {
    await _simulateDelay();
    _maybeThrowError();

    if (!_labOrders.containsKey(result.labOrderId)) {
      throw Exception('Lab order not found');
    }

    final newResult = LabResult(
      id: _labResults.length + 1,
      labOrderId: result.labOrderId,
      result: result.result,
      isAbnormal: result.isAbnormal,
      notes: result.notes,
      technicianId: result.technicianId,
      resultTime: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _labResults[result.labOrderId] = newResult;
    return newResult;
  }

  @override
  Future<LabResult?> getOrderResult(int labOrderId) async {
    await _simulateDelay();
    _maybeThrowError();

    return _labResults[labOrderId];
  }

  @override
  Future<List<Map<String, dynamic>>> getPatientHistory(int patientId) async {
    await _simulateDelay();
    _maybeThrowError();

    // This would need to access visits to get patient's lab history
    // For now, return empty list as this requires visit repository access
    return [];
  }

  @override
  Future<List<LabTestCatalog>> getCatalog() async {
    await _simulateDelay();
    _maybeThrowError();

    return _labTestCatalog.values.toList();
  }

  @override
  Future<List<LabTestCatalog>> searchTests(String query) async {
    await _simulateDelay();
    _maybeThrowError();

    final normalizedQuery = query.toLowerCase().trim();
    
    if (normalizedQuery.isEmpty) {
      return _labTestCatalog.values.toList();
    }

    return _labTestCatalog.values.where((t) {
      return t.name.toLowerCase().contains(normalizedQuery) ||
             t.code.toLowerCase().contains(normalizedQuery) ||
             t.category.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  // Reset data to initial state
  void resetData() {
    _labOrders.clear();
    _labResults.clear();
    _nextOrderId = 1;
    _seedData();
  }

  // Helper to get lab test by ID
  LabTestCatalog? getLabTestById(int id) {
    return _labTestCatalog[id];
  }

  // Helper to get all orders
  List<LabOrder> getAllOrders() {
    return _labOrders.values.toList();
  }
}
