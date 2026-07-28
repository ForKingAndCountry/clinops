class ReportSummary {
  final int totalPatients;
  final int totalVisits;
  final int opdVisits;
  final int ipdAdmissions;
  final int activeAdmissions;
  final double totalRevenue;
  final double pendingPayments;
  final DateTime reportDate;
  final DateTime? startDate;
  final DateTime? endDate;

  ReportSummary({
    required this.totalPatients,
    required this.totalVisits,
    required this.opdVisits,
    required this.ipdAdmissions,
    required this.activeAdmissions,
    required this.totalRevenue,
    required this.pendingPayments,
    required this.reportDate,
    this.startDate,
    this.endDate,
  });

  ReportSummary copyWith({
    int? totalPatients,
    int? totalVisits,
    int? opdVisits,
    int? ipdAdmissions,
    int? activeAdmissions,
    double? totalRevenue,
    double? pendingPayments,
    DateTime? reportDate,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ReportSummary(
      totalPatients: totalPatients ?? this.totalPatients,
      totalVisits: totalVisits ?? this.totalVisits,
      opdVisits: opdVisits ?? this.opdVisits,
      ipdAdmissions: ipdAdmissions ?? this.ipdAdmissions,
      activeAdmissions: activeAdmissions ?? this.activeAdmissions,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      pendingPayments: pendingPayments ?? this.pendingPayments,
      reportDate: reportDate ?? this.reportDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_patients': totalPatients,
      'total_visits': totalVisits,
      'opd_visits': opdVisits,
      'ipd_admissions': ipdAdmissions,
      'active_admissions': activeAdmissions,
      'total_revenue': totalRevenue,
      'pending_payments': pendingPayments,
      'report_date': reportDate.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalPatients: json['total_patients'] as int,
      totalVisits: json['total_visits'] as int,
      opdVisits: json['opd_visits'] as int,
      ipdAdmissions: json['ipd_admissions'] as int,
      activeAdmissions: json['active_admissions'] as int,
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      pendingPayments: (json['pending_payments'] as num).toDouble(),
      reportDate: DateTime.parse(json['report_date'] as String),
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
    );
  }
}

class DiagnosisBreakdown {
  final String diagnosisCode;
  final String diagnosisName;
  final int count;
  final double percentage;

  DiagnosisBreakdown({
    required this.diagnosisCode,
    required this.diagnosisName,
    required this.count,
    required this.percentage,
  });

  DiagnosisBreakdown copyWith({
    String? diagnosisCode,
    String? diagnosisName,
    int? count,
    double? percentage,
  }) {
    return DiagnosisBreakdown(
      diagnosisCode: diagnosisCode ?? this.diagnosisCode,
      diagnosisName: diagnosisName ?? this.diagnosisName,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diagnosis_code': diagnosisCode,
      'diagnosis_name': diagnosisName,
      'count': count,
      'percentage': percentage,
    };
  }

  factory DiagnosisBreakdown.fromJson(Map<String, dynamic> json) {
    return DiagnosisBreakdown(
      diagnosisCode: json['diagnosis_code'] as String,
      diagnosisName: json['diagnosis_name'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
