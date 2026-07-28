class Patient {
  final int? id;
  final String hospitalId;
  final String firstName;
  final String lastName;
  final String normalized_name;
  final DateTime dateOfBirth;
  final String? phone;
  final String? community;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? allergies;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    this.id,
    required this.hospitalId,
    required this.firstName,
    required this.lastName,
    required this.normalized_name,
    required this.dateOfBirth,
    this.phone,
    this.community,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.allergies,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  Patient copyWith({
    int? id,
    String? hospitalId,
    String? firstName,
    String? lastName,
    String? normalized_name,
    DateTime? dateOfBirth,
    String? phone,
    String? community,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? allergies,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      hospitalId: hospitalId ?? this.hospitalId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      normalized_name: normalized_name ?? this.normalized_name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      community: community ?? this.community,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      allergies: allergies ?? this.allergies,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospital_id': hospitalId,
      'first_name': firstName,
      'last_name': lastName,
      'normalized_name': normalized_name,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'phone': phone,
      'community': community,
      'address': address,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'allergies': allergies,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as int?,
      hospitalId: json['hospital_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      normalized_name: json['normalized_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      phone: json['phone'] as String?,
      community: json['community'] as String?,
      address: json['address'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      allergies: json['allergies'] as String?,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
