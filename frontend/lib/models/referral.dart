class Referral {
  final int? id;
  final int patientId;
  final int visitId;
  final String facilityName;
  final String? facilityAddress;
  final String? referralReason;
  final String? referringDoctorNotes;
  final DateTime? referralDate;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Referral({
    this.id,
    required this.patientId,
    required this.visitId,
    required this.facilityName,
    this.facilityAddress,
    this.referralReason,
    this.referringDoctorNotes,
    this.referralDate,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Referral copyWith({
    int? id,
    int? patientId,
    int? visitId,
    String? facilityName,
    String? facilityAddress,
    String? referralReason,
    String? referringDoctorNotes,
    DateTime? referralDate,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Referral(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      visitId: visitId ?? this.visitId,
      facilityName: facilityName ?? this.facilityName,
      facilityAddress: facilityAddress ?? this.facilityAddress,
      referralReason: referralReason ?? this.referralReason,
      referringDoctorNotes: referringDoctorNotes ?? this.referringDoctorNotes,
      referralDate: referralDate ?? this.referralDate,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'visit_id': visitId,
      'facility_name': facilityName,
      'facility_address': facilityAddress,
      'referral_reason': referralReason,
      'referring_doctor_notes': referringDoctorNotes,
      'referral_date': referralDate?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'] as int?,
      patientId: json['patient_id'] as int,
      visitId: json['visit_id'] as int,
      facilityName: json['facility_name'] as String,
      facilityAddress: json['facility_address'] as String?,
      referralReason: json['referral_reason'] as String?,
      referringDoctorNotes: json['referring_doctor_notes'] as String?,
      referralDate: json['referral_date'] != null ? DateTime.parse(json['referral_date'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
