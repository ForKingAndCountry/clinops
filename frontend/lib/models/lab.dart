class LabTestCatalog {
  final int? id;
  final String code;
  final String name;
  final String category; // e.g., 'Hematology', 'Chemistry', 'Microbiology'
  final String resultType; // 'numeric', 'text', 'boolean'
  final String? unit;
  final String? normalRange;
  final String? normalRangeLow;
  final String? normalRangeHigh;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  LabTestCatalog({
    this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.resultType,
    this.unit,
    this.normalRange,
    this.normalRangeLow,
    this.normalRangeHigh,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  LabTestCatalog copyWith({
    int? id,
    String? code,
    String? name,
    String? category,
    String? resultType,
    String? unit,
    String? normalRange,
    String? normalRangeLow,
    String? normalRangeHigh,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabTestCatalog(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      resultType: resultType ?? this.resultType,
      unit: unit ?? this.unit,
      normalRange: normalRange ?? this.normalRange,
      normalRangeLow: normalRangeLow ?? this.normalRangeLow,
      normalRangeHigh: normalRangeHigh ?? this.normalRangeHigh,
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
      'category': category,
      'result_type': resultType,
      'unit': unit,
      'normal_range': normalRange,
      'normal_range_low': normalRangeLow,
      'normal_range_high': normalRangeHigh,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LabTestCatalog.fromJson(Map<String, dynamic> json) {
    return LabTestCatalog(
      id: json['id'] as int?,
      code: json['code'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      resultType: json['result_type'] as String,
      unit: json['unit'] as String?,
      normalRange: json['normal_range'] as String?,
      normalRangeLow: json['normal_range_low'] as String?,
      normalRangeHigh: json['normal_range_high'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class LabOrder {
  final int? id;
  final int visitId;
  final int? encounterId;
  final int labTestId;
  final DateTime? orderedAt;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  LabOrder({
    this.id,
    required this.visitId,
    this.encounterId,
    required this.labTestId,
    this.orderedAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  LabOrder copyWith({
    int? id,
    int? visitId,
    int? encounterId,
    int? labTestId,
    DateTime? orderedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabOrder(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      encounterId: encounterId ?? this.encounterId,
      labTestId: labTestId ?? this.labTestId,
      orderedAt: orderedAt ?? this.orderedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'encounter_id': encounterId,
      'lab_test_id': labTestId,
      'ordered_at': orderedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LabOrder.fromJson(Map<String, dynamic> json) {
    return LabOrder(
      id: json['id'] as int?,
      visitId: json['visit_id'] as int,
      encounterId: json['encounter_id'] as int?,
      labTestId: json['lab_test_id'] as int,
      orderedAt: json['ordered_at'] != null ? DateTime.parse(json['ordered_at'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class LabResult {
  final int? id;
  final int labOrderId;
  final String result;
  final bool isAbnormal;
  final String? notes;
  final int? technicianId;
  final DateTime? resultTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  LabResult({
    this.id,
    required this.labOrderId,
    required this.result,
    required this.isAbnormal,
    this.notes,
    this.technicianId,
    this.resultTime,
    required this.createdAt,
    required this.updatedAt,
  });

  LabResult copyWith({
    int? id,
    int? labOrderId,
    String? result,
    bool? isAbnormal,
    String? notes,
    int? technicianId,
    DateTime? resultTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabResult(
      id: id ?? this.id,
      labOrderId: labOrderId ?? this.labOrderId,
      result: result ?? this.result,
      isAbnormal: isAbnormal ?? this.isAbnormal,
      notes: notes ?? this.notes,
      technicianId: technicianId ?? this.technicianId,
      resultTime: resultTime ?? this.resultTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lab_order_id': labOrderId,
      'result': result,
      'is_abnormal': isAbnormal,
      'notes': notes,
      'technician_id': technicianId,
      'result_time': resultTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      id: json['id'] as int?,
      labOrderId: json['lab_order_id'] as int,
      result: json['result'] as String,
      isAbnormal: json['is_abnormal'] as bool,
      notes: json['notes'] as String?,
      technicianId: json['technician_id'] as int?,
      resultTime: json['result_time'] != null ? DateTime.parse(json['result_time'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
