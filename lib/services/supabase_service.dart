import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  Future<List<Product>> fetchProducts({
    required double minPrice,
    required double maxPrice,
    required int page,
    int itemsPerPage = 6,
  }) async {
    final int from = page * itemsPerPage;
    final int to = from + itemsPerPage - 1;

    final response = await _supabase
        .from('products')
        .select()
        .gte('price', minPrice)
        .lte('price', maxPrice)
        .order('id', ascending: true)
        .range(from, to);

    return (response as List).map((json) => Product.fromJson(json)).toList();
  }
}
