class OrderItemModel {
  final int id;
  final String productName;
  final double unitPrice;
  final int quantity;

  OrderItemModel({
    required this.id,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  double get subtotal => unitPrice * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productName: json['product_name'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }
}

class OrderModel {
  final int id;
  final String userId;
  final String? customerEmail;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    this.customerEmail,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final profileData = json['profiles'] as Map<String, dynamic>?;
    final rawItems = (json['order_items'] as List?) ?? [];
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      customerEmail: profileData?['email'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] ?? 'done',
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      items: rawItems.map((e) => OrderItemModel.fromJson(e)).toList(),
    );
  }
}
