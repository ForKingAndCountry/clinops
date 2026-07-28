class DiagnosisCatalog {
  final int? id;
  final String code; // ICD-10 or local code
  final String name;
  final String? description;
  final String category; // e.g., 'Infectious', 'Chronic', etc.
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiagnosisCatalog({
    this.id,
    required this.code,
    required this.name,
    this.description,
    required this.category,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  DiagnosisCatalog copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiagnosisCatalog(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'category': category,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DiagnosisCatalog.fromJson(Map<String, dynamic> json) {
    return DiagnosisCatalog(
      id: json['id'] as int?,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class EncounterDiagnosis {
  final int? id;
  final int encounterId;
  final int diagnosisId;
  final bool isPrimary;
  final DateTime createdAt;

  EncounterDiagnosis({
    this.id,
    required this.encounterId,
    required this.diagnosisId,
    required this.isPrimary,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'diagnosis_id': diagnosisId,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory EncounterDiagnosis.fromJson(Map<String, dynamic> json) {
    return EncounterDiagnosis(
      id: json['id'] as int?,
      encounterId: json['encounter_id'] as int,
      diagnosisId: json['diagnosis_id'] as int,
      isPrimary: json['is_primary'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
