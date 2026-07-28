class DrugFormularyItem {
  final int? id;
  final String name;
  final String genericName;
  final String? manufacturer;
  final String strength;
  final String unit;
  final String form; // tablet, capsule, injection, syrup, etc.
  final int stockQuantity;
  final int minStockLevel;
  final String? storageRequirements;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  DrugFormularyItem({
    this.id,
    required this.name,
    required this.genericName,
    this.manufacturer,
    required this.strength,
    required this.unit,
    required this.form,
    required this.stockQuantity,
    required this.minStockLevel,
    this.storageRequirements,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  DrugFormularyItem copyWith({
    int? id,
    String? name,
    String? genericName,
    String? manufacturer,
    String? strength,
    String? unit,
    String? form,
    int? stockQuantity,
    int? minStockLevel,
    String? storageRequirements,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DrugFormularyItem(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      manufacturer: manufacturer ?? this.manufacturer,
      strength: strength ?? this.strength,
      unit: unit ?? this.unit,
      form: form ?? this.form,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      storageRequirements: storageRequirements ?? this.storageRequirements,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isLowStock => stockQuantity <= minStockLevel;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'manufacturer': manufacturer,
      'strength': strength,
      'unit': unit,
      'form': form,
      'stock_quantity': stockQuantity,
      'min_stock_level': minStockLevel,
      'storage_requirements': storageRequirements,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DrugFormularyItem.fromJson(Map<String, dynamic> json) {
    return DrugFormularyItem(
      id: json['id'] as int?,
      name: json['name'] as String,
      genericName: json['generic_name'] as String,
      manufacturer: json['manufacturer'] as String?,
      strength: json['strength'] as String,
      unit: json['unit'] as String,
      form: json['form'] as String,
      stockQuantity: json['stock_quantity'] as int,
      minStockLevel: json['min_stock_level'] as int,
      storageRequirements: json['storage_requirements'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class Prescription {
  final int? id;
  final int visitId;
  final int? encounterId;
  final DateTime? prescribedAt;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Prescription({
    this.id,
    required this.visitId,
    this.encounterId,
    this.prescribedAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Prescription copyWith({
    int? id,
    int? visitId,
    int? encounterId,
    DateTime? prescribedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Prescription(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      encounterId: encounterId ?? this.encounterId,
      prescribedAt: prescribedAt ?? this.prescribedAt,
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
      'prescribed_at': prescribedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as int?,
      visitId: json['visit_id'] as int,
      encounterId: json['encounter_id'] as int?,
      prescribedAt: json['prescribed_at'] != null ? DateTime.parse(json['prescribed_at'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class PrescriptionItem {
  final int? id;
  final int prescriptionId;
  final int drugId;
  final String dose;
  final String doseUnit;
  final String route; // oral, intravenous, intramuscular, etc.
  final String frequency; // once daily, twice daily, etc.
  final String duration;
  final String? notes; // for doctor reference only
  final bool isDispensed;
  final DateTime? dispensedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrescriptionItem({
    this.id,
    required this.prescriptionId,
    required this.drugId,
    required this.dose,
    required this.doseUnit,
    required this.route,
    required this.frequency,
    required this.duration,
    this.notes,
    required this.isDispensed,
    this.dispensedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  PrescriptionItem copyWith({
    int? id,
    int? prescriptionId,
    int? drugId,
    String? dose,
    String? doseUnit,
    String? route,
    String? frequency,
    String? duration,
    String? notes,
    bool? isDispensed,
    DateTime? dispensedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrescriptionItem(
      id: id ?? this.id,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      drugId: drugId ?? this.drugId,
      dose: dose ?? this.dose,
      doseUnit: doseUnit ?? this.doseUnit,
      route: route ?? this.route,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      isDispensed: isDispensed ?? this.isDispensed,
      dispensedAt: dispensedAt ?? this.dispensedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescription_id': prescriptionId,
      'drug_id': drugId,
      'dose': dose,
      'dose_unit': doseUnit,
      'route': route,
      'frequency': frequency,
      'duration': duration,
      'notes': notes,
      'is_dispensed': isDispensed,
      'dispensed_at': dispensedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      id: json['id'] as int?,
      prescriptionId: json['prescription_id'] as int,
      drugId: json['drug_id'] as int,
      dose: json['dose'] as String,
      doseUnit: json['dose_unit'] as String,
      route: json['route'] as String,
      frequency: json['frequency'] as String,
      duration: json['duration'] as String,
      notes: json['notes'] as String?,
      isDispensed: json['is_dispensed'] as bool,
      dispensedAt: json['dispensed_at'] != null ? DateTime.parse(json['dispensed_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
