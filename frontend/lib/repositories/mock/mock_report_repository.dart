import 'dart:async';
import 'dart:math';
import '../report_repository.dart';
import '../../models/reports.dart';

class MockReportRepository implements ReportRepository {
  final Random _random = Random();
  bool _simulateErrors = false;

  MockReportRepository();

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
  Future<ReportSummary> getSummary({DateTime? startDate, DateTime? endDate}) async {
    await _simulateDelay();
    _maybeThrowError();

    final now = DateTime.now();
    final start = startDate ?? now.subtract(const Duration(days: 30));
    final end = endDate ?? now;

    // Generate mock summary data
    return ReportSummary(
      totalPatients: 200 + _random.nextInt(50),
      totalVisits: 450 + _random.nextInt(100),
      opdVisits: 380 + _random.nextInt(80),
      ipdAdmissions: 70 + _random.nextInt(20),
      activeAdmissions: 15 + _random.nextInt(10),
      totalRevenue: 150000.0 + _random.nextDouble() * 50000.0,
      pendingPayments: 20000.0 + _random.nextDouble() * 10000.0,
      reportDate: now,
      startDate: start,
      endDate: end,
    );
  }

  @override
  Future<Map<String, dynamic>> getOPDSummary({DateTime? startDate, DateTime? endDate}) async {
    await _simulateDelay();
    _maybeThrowError();

    final now = DateTime.now();
    final start = startDate ?? now.subtract(const Duration(days: 30));
    final end = endDate ?? now;

    return {
      'total_visits': 380 + _random.nextInt(80),
      'average_daily_visits': 12 + _random.nextInt(5),
      'peak_hour': '10:00 AM',
      'top_diagnoses': [
        {'code': 'J00', 'name': 'Common Cold', 'count': 45},
        {'code': 'A09', 'name': 'Gastroenteritis', 'count': 32},
        {'code': 'B60', 'name': 'Malaria', 'count': 28},
        {'code': 'I10', 'name': 'Hypertension', 'count': 25},
        {'code': 'E11', 'name': 'Type 2 Diabetes', 'count': 18},
      ],
      'start_date': start,
      'end_date': end,
    };
  }

  @override
  Future<Map<String, dynamic>> getIPDSummary({DateTime? startDate, DateTime? endDate}) async {
    await _simulateDelay();
    _maybeThrowError();

    final now = DateTime.now();
    final start = startDate ?? now.subtract(const Duration(days: 30));
    final end = endDate ?? now;

    return {
      'total_admissions': 70 + _random.nextInt(20),
      'active_admissions': 15 + _random.nextInt(10),
      'average_length_of_stay': 4.5 + _random.nextDouble() * 2.0,
      'occupancy_rate': 0.65 + _random.nextDouble() * 0.2,
      'top_admission_reasons': [
        {'code': 'I50', 'name': 'Heart Failure', 'count': 12},
        {'code': 'J18', 'name': 'Pneumonia', 'count': 10},
        {'code': 'E40', 'name': 'Severe Malnutrition', 'count': 8},
        {'code': 'O80', 'name': 'Normal Delivery', 'count': 15},
        {'code': 'K35', 'name': 'Acute Appendicitis', 'count': 6},
      ],
      'start_date': start,
      'end_date': end,
    };
  }

  @override
  Future<Map<String, dynamic>> getDailySummary(DateTime date) async {
    await _simulateDelay();
    _maybeThrowError();

    return {
      'date': date,
      'patient_count': 15 + _random.nextInt(10),
      'visit_count': 20 + _random.nextInt(15),
      'admission_count': 2 + _random.nextInt(3),
      'discharge_count': 1 + _random.nextInt(2),
      'revenue': 8000.0 + _random.nextDouble() * 4000.0,
      'payments': 15 + _random.nextInt(10),
    };
  }

  @override
  Future<List<DiagnosisBreakdown>> getDiagnosisBreakdown({DateTime? startDate, DateTime? endDate}) async {
    await _simulateDelay();
    _maybeThrowError();

    final diagnoses = [
      DiagnosisBreakdown(
        diagnosisCode: 'J00',
        diagnosisName: 'Common Cold',
        count: 45,
        percentage: 12.5,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'A09',
        diagnosisName: 'Gastroenteritis',
        count: 32,
        percentage: 8.9,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'B60',
        diagnosisName: 'Malaria',
        count: 28,
        percentage: 7.8,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'I10',
        diagnosisName: 'Hypertension',
        count: 25,
        percentage: 7.0,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'E11',
        diagnosisName: 'Type 2 Diabetes',
        count: 18,
        percentage: 5.0,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'J18',
        diagnosisName: 'Pneumonia',
        count: 15,
        percentage: 4.2,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'E40',
        diagnosisName: 'Severe Malnutrition',
        count: 12,
        percentage: 3.4,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'O80',
        diagnosisName: 'Normal Delivery',
        count: 15,
        percentage: 4.2,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'A01',
        diagnosisName: 'Typhoid Fever',
        count: 10,
        percentage: 2.8,
      ),
      DiagnosisBreakdown(
        diagnosisCode: 'J45',
        diagnosisName: 'Asthma',
        count: 8,
        percentage: 2.2,
      ),
    ];

    return diagnoses;
  }

  @override
  Future<Map<String, dynamic>> getRevenueSummary({DateTime? startDate, DateTime? endDate}) async {
    await _simulateDelay();
    _maybeThrowError();

    final now = DateTime.now();
    final start = startDate ?? now.subtract(const Duration(days: 30));
    final end = endDate ?? now;

    return {
      'total_revenue': 150000.0 + _random.nextDouble() * 50000.0,
      'consultation_revenue': 50000.0 + _random.nextDouble() * 10000.0,
      'lab_revenue': 30000.0 + _random.nextDouble() * 8000.0,
      'pharmacy_revenue': 45000.0 + _random.nextDouble() * 15000.0,
      'procedure_revenue': 15000.0 + _random.nextDouble() * 5000.0,
      'bed_charge_revenue': 10000.0 + _random.nextDouble() * 3000.0,
      'payment_methods': {
        'cash': 0.6,
        'mobile_money': 0.25,
        'insurance': 0.1,
        'bank_transfer': 0.05,
      },
      'start_date': start,
      'end_date': end,
    };
  }

  // Reset data to initial state (no-op for this simple mock)
  void resetData() {
    // No persistent state to reset
  }
}
