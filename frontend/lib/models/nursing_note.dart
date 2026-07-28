class NursingNote {
  final int? id;
  final int admissionId;
  final String notes;
  final int? nurseId;
  final DateTime noteTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  NursingNote({
    this.id,
    required this.admissionId,
    required this.notes,
    this.nurseId,
    required this.noteTime,
    required this.createdAt,
    required this.updatedAt,
  });

  NursingNote copyWith({
    int? id,
    int? admissionId,
    String? notes,
    int? nurseId,
    DateTime? noteTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NursingNote(
      id: id ?? this.id,
      admissionId: admissionId ?? this.admissionId,
      notes: notes ?? this.notes,
      nurseId: nurseId ?? this.nurseId,
      noteTime: noteTime ?? this.noteTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admission_id': admissionId,
      'notes': notes,
      'nurse_id': nurseId,
      'note_time': noteTime.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory NursingNote.fromJson(Map<String, dynamic> json) {
    return NursingNote(
      id: json['id'] as int?,
      admissionId: json['admission_id'] as int,
      notes: json['notes'] as String,
      nurseId: json['nurse_id'] as int?,
      noteTime: DateTime.parse(json['note_time'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
