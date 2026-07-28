enum VisitStatus {
  reception,
  vitals,
  doctor,
  lab,
  pharmacy,
  billing,
  discharged,
}

class Visit {
  final int? id;
  final int patientId;
  final VisitStatus status;
  final String visitType; // 'OPD' or 'IPD'
  final DateTime? arrivalTime;
  final DateTime? dischargeTime;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Visit({
    this.id,
    required this.patientId,
    required this.status,
    required this.visitType,
    this.arrivalTime,
    this.dischargeTime,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Visit copyWith({
    int? id,
    int? patientId,
    VisitStatus? status,
    String? visitType,
    DateTime? arrivalTime,
    DateTime? dischargeTime,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Visit(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      status: status ?? this.status,
      visitType: visitType ?? this.visitType,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      dischargeTime: dischargeTime ?? this.dischargeTime,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'status': status.name,
      'visit_type': visitType,
      'arrival_time': arrivalTime?.toIso8601String(),
      'discharge_time': dischargeTime?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as int?,
      patientId: json['patient_id'] as int,
      status: VisitStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => VisitStatus.reception,
      ),
      visitType: json['visit_type'] as String,
      arrivalTime: json['arrival_time'] != null ? DateTime.parse(json['arrival_time'] as String) : null,
      dischargeTime: json['discharge_time'] != null ? DateTime.parse(json['discharge_time'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class VisitTransition {
  final int? id;
  final int visitId;
  final VisitStatus fromStatus;
  final VisitStatus toStatus;
  final DateTime transitionedAt;
  final int? actorUserId;
  final DateTime createdAt;

  VisitTransition({
    this.id,
    required this.visitId,
    required this.fromStatus,
    required this.toStatus,
    required this.transitionedAt,
    this.actorUserId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'from_status': fromStatus.name,
      'to_status': toStatus.name,
      'transitioned_at': transitionedAt.toIso8601String(),
      'actor_user_id': actorUserId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory VisitTransition.fromJson(Map<String, dynamic> json) {
    return VisitTransition(
      id: json['id'] as int?,
      visitId: json['visit_id'] as int,
      fromStatus: VisitStatus.values.firstWhere(
        (e) => e.name == json['from_status'],
        orElse: () => VisitStatus.reception,
      ),
      toStatus: VisitStatus.values.firstWhere(
        (e) => e.name == json['to_status'],
        orElse: () => VisitStatus.reception,
      ),
      transitionedAt: DateTime.parse(json['transitioned_at'] as String),
      actorUserId: json['actor_user_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
