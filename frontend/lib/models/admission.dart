class Ward {
  final int? id;
  final String name;
  final String code;
  final int capacity;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ward({
    this.id,
    required this.name,
    required this.code,
    required this.capacity,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Ward copyWith({
    int? id,
    String? name,
    String? code,
    int? capacity,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ward(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      capacity: capacity ?? this.capacity,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'capacity': capacity,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['id'] as int?,
      name: json['name'] as String,
      code: json['code'] as String,
      capacity: json['capacity'] as int,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

enum BedStatus {
  free,
  occupied,
  maintenance,
}

class Bed {
  final int? id;
  final int wardId;
  final String bedNumber;
  final BedStatus status;
  final int? currentAdmissionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bed({
    this.id,
    required this.wardId,
    required this.bedNumber,
    required this.status,
    this.currentAdmissionId,
    required this.createdAt,
    required this.updatedAt,
  });

  Bed copyWith({
    int? id,
    int? wardId,
    String? bedNumber,
    BedStatus? status,
    int? currentAdmissionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bed(
      id: id ?? this.id,
      wardId: wardId ?? this.wardId,
      bedNumber: bedNumber ?? this.bedNumber,
      status: status ?? this.status,
      currentAdmissionId: currentAdmissionId ?? this.currentAdmissionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ward_id': wardId,
      'bed_number': bedNumber,
      'status': status.name,
      'current_admission_id': currentAdmissionId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'] as int?,
      wardId: json['ward_id'] as int,
      bedNumber: json['bed_number'] as String,
      status: BedStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BedStatus.free,
      ),
      currentAdmissionId: json['current_admission_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class Admission {
  final int? id;
  final int patientId;
  final int bedId;
  final DateTime admissionDate;
  final DateTime? dischargeDate;
  final String? dischargeReason;
  final int? admittingDoctorId;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Admission({
    this.id,
    required this.patientId,
    required this.bedId,
    required this.admissionDate,
    this.dischargeDate,
    this.dischargeReason,
    this.admittingDoctorId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Admission copyWith({
    int? id,
    int? patientId,
    int? bedId,
    DateTime? admissionDate,
    DateTime? dischargeDate,
    String? dischargeReason,
    int? admittingDoctorId,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Admission(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      bedId: bedId ?? this.bedId,
      admissionDate: admissionDate ?? this.admissionDate,
      dischargeDate: dischargeDate ?? this.dischargeDate,
      dischargeReason: dischargeReason ?? this.dischargeReason,
      admittingDoctorId: admittingDoctorId ?? this.admittingDoctorId,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => dischargeDate == null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'bed_id': bedId,
      'admission_date': admissionDate.toIso8601String(),
      'discharge_date': dischargeDate?.toIso8601String(),
      'discharge_reason': dischargeReason,
      'admitting_doctor_id': admittingDoctorId,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Admission.fromJson(Map<String, dynamic> json) {
    return Admission(
      id: json['id'] as int?,
      patientId: json['patient_id'] as int,
      bedId: json['bed_id'] as int,
      admissionDate: DateTime.parse(json['admission_date'] as String),
      dischargeDate: json['discharge_date'] != null ? DateTime.parse(json['discharge_date'] as String) : null,
      dischargeReason: json['discharge_reason'] as String?,
      admittingDoctorId: json['admitting_doctor_id'] as int?,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
