class BillingItem {
  final int? id;
  final int visitId;
  final String itemType; // 'consultation', 'lab', 'drug', 'procedure', 'bed_charge'
  final int? itemId; // reference to lab_order, prescription_item, etc.
  final String description;
  final double amount;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  BillingItem({
    this.id,
    required this.visitId,
    required this.itemType,
    this.itemId,
    required this.description,
    required this.amount,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  BillingItem copyWith({
    int? id,
    int? visitId,
    String? itemType,
    int? itemId,
    String? description,
    double? amount,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillingItem(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'item_type': itemType,
      'item_id': itemId,
      'description': description,
      'amount': amount,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BillingItem.fromJson(Map<String, dynamic> json) {
    return BillingItem(
      id: json['id'] as int?,
      visitId: json['visit_id'] as int,
      itemType: json['item_type'] as String,
      itemId: json['item_id'] as int?,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class Payment {
  final int? id;
  final int visitId;
  final double amount;
  final String paymentMethod; // 'cash', 'mobile_money', 'insurance', 'bank_transfer'
  final String? referenceNumber;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    this.id,
    required this.visitId,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Payment copyWith({
    int? id,
    int? visitId,
    double? amount,
    String? paymentMethod,
    String? referenceNumber,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'amount': amount,
      'payment_method': paymentMethod,
      'reference_number': referenceNumber,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as int?,
      visitId: json['visit_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      referenceNumber: json['reference_number'] as String?,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
