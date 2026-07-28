import '../models/reports.dart';

abstract class ReportRepository {
  // Get overall report summary
  Future<ReportSummary> getSummary({DateTime? startDate, DateTime? endDate});
  
  // Get OPD summary
  Future<Map<String, dynamic>> getOPDSummary({DateTime? startDate, DateTime? endDate});
  
  // Get IPD summary
  Future<Map<String, dynamic>> getIPDSummary({DateTime? startDate, DateTime? endDate});
  
  // Get daily summary
  Future<Map<String, dynamic>> getDailySummary(DateTime date);
  
  // Get diagnosis breakdown
  Future<List<DiagnosisBreakdown>> getDiagnosisBreakdown({DateTime? startDate, DateTime? endDate});
  
  // Get revenue summary
  Future<Map<String, dynamic>> getRevenueSummary({DateTime? startDate, DateTime? endDate});
}
