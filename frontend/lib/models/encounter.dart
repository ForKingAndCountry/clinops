class Encounter {
  final int? id;
  final int visitId;
  final int? doctorId;
  final String clinicalNotes;
  final DateTime encounterTime;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Encounter({
    this.id,
    required this.visitId,
    this.doctorId,
    required this.clinicalNotes,
    required this.encounterTime,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Encounter copyWith({
    int? id,
    int? visitId,
    int? doctorId,
    String? clinicalNotes,
    DateTime? encounterTime,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Encounter(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      doctorId: doctorId ?? this.doctorId,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      encounterTime: encounterTime ?? this.encounterTime,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'doctor_id': doctorId,
      'clinical_notes': clinicalNotes,
      'encounter_time': encounterTime.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Encounter.fromJson(Map<String, dynamic> json) {
    return Encounter(
      id: json['id'] as int?,
      visitId: json['visit_id'] as int,
      doctorId: json['doctor_id'] as int?,
      clinicalNotes: json['clinical_notes'] as String,
      encounterTime: DateTime.parse(json['encounter_time'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
