class VitalsRecord {
  final int? id;
  final int? visitId;
  final int? admissionId;
  final double? temperature;
  final int? systolicBP;
  final int? diastolicBP;
  final int? heartRate;
  final int? respiratoryRate;
  final double? oxygenSaturation;
  final double? weight;
  final double? height;
  final String? notes;
  final DateTime recordedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  VitalsRecord({
    this.id,
    this.visitId,
    this.admissionId,
    this.temperature,
    this.systolicBP,
    this.diastolicBP,
    this.heartRate,
    this.respiratoryRate,
    this.oxygenSaturation,
    this.weight,
    this.height,
    this.notes,
    required this.recordedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  VitalsRecord copyWith({
    int? id,
    int? visitId,
    int? admissionId,
    double? temperature,
    int? systolicBP,
    int? diastolicBP,
    int? heartRate,
    int? respiratoryRate,
    double? oxygenSaturation,
    double? weight,
    double? height,
    String? notes,
    DateTime? recordedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VitalsRecord(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      admissionId: admissionId ?? this.admissionId,
      temperature: temperature ?? this.temperature,
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
      heartRate: heartRate ?? this.heartRate,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      oxygenSaturation: oxygenSaturation ?? this.oxygenSaturation,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'admission_id': admissionId,
      'temperature': temperature,
      'systolic_bp': systolicBP,
      'diastolic_bp': diastolicBP,
      'heart_rate': heartRate,
      'respiratory_rate': respiratoryRate,
      'oxygen_saturation': oxygenSaturation,
      'weight': weight,
      'height': height,
      'notes': notes,
      'recorded_at': recordedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory VitalsRecord.fromJson(Map<String, dynamic> json) {
    return VitalsRecord(
      id: json['id'] as int?,
      visitId: json['visit_id'] as int?,
      admissionId: json['admission_id'] as int?,
      temperature: json['temperature'] as double?,
      systolicBP: json['systolic_bp'] as int?,
      diastolicBP: json['diastolic_bp'] as int?,
      heartRate: json['heart_rate'] as int?,
      respiratoryRate: json['respiratory_rate'] as int?,
      oxygenSaturation: json['oxygen_saturation'] as double?,
      weight: json['weight'] as double?,
      height: json['height'] as double?,
      notes: json['notes'] as String?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
