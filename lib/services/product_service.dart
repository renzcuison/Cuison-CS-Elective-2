import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Product>> fetchProducts({
    required double minPrice,
    required double maxPrice,
    required int page,
    int itemsPerPage = 6,
    int? categoryId,
    String searchQuery = '',
  }) async {
    final int from = page * itemsPerPage;
    final int to = from + itemsPerPage - 1;

    var query = _supabase
        .from('products')
        .select('*, categories(name)')
        .gte('price', minPrice)
        .lte('price', maxPrice);

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    if (searchQuery.trim().isNotEmpty) {
      query = query.ilike('name', '%${searchQuery.trim()}%');
    }

    final response = await query.order('id', ascending: false).range(from, to);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    int? categoryId,
    String? imageUrl,
  }) async {
    await _supabase.from('products').insert({
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
      'image_url': imageUrl,
    });
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int stock,
    int? categoryId,
    String? imageUrl,
  }) async {
    await _supabase
        .from('products')
        .update({
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
          'category_id': categoryId,
          'image_url': imageUrl,
        })
        .eq('id', id);
  }

  Future<void> deleteProduct(int id) async {
    await _supabase.from('products').delete().eq('id', id);
  }
}
