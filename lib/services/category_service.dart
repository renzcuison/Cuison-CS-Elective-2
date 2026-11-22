import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Category>> fetchCategories() async {
    final response = await _supabase
        .from('categories')
        .select()
        .order('name', ascending: true);
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  Future<void> addCategory(String name) async {
    await _supabase.from('categories').insert({'name': name.trim()});
  }

  Future<void> updateCategory(int id, String name) async {
    await _supabase
        .from('categories')
        .update({'name': name.trim()})
        .eq('id', id);
  }

  Future<void> deleteCategory(int id) async {
    await _supabase.from('categories').delete().eq('id', id);
  }
}
