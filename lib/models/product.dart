class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int? categoryId;
  final String? categoryName;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.stock,
    this.categoryId,
    this.categoryName,
    this.imageUrl,
  });

  bool get isInStock => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    final categoryData = json['categories'] as Map<String, dynamic>?;
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      categoryId: json['category_id'],
      categoryName: categoryData?['name'],
      imageUrl: json['image_url'],
    );
  }
}
