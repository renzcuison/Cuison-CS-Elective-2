import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // Fetches products with price filtering and 6 items per page pagination
  Future<List<Product>> fetchProducts({
    required double minPrice,
    required double maxPrice,
    required int page,
    int itemsPerPage = 6, // 6 items per page (within 6-8 requirement)
  }) async {
    final int from = page * itemsPerPage;
    final int to = from + itemsPerPage - 1;

    final response = await _supabase
        .from('products')
        .select()
        .gte('price', minPrice) // Filter minimum price
        .lte('price', maxPrice) // Filter maximum price
        .order('id', ascending: true)
        .range(from, to);       // Supabase backend pagination query

    return (response as List).map((json) => Product.fromJson(json)).toList();
  }
}