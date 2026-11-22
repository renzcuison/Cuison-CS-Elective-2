import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_item.dart';
import '../models/order_model.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<dynamic> checkout(List<CartItem> cartItems) async {
    final payload = cartItems
        .map(
          (item) => {'product_id': item.product.id, 'quantity': item.quantity},
        )
        .toList();

    final response = await _supabase.rpc(
      'place_order',
      params: {'p_items': payload},
    );
    return Map<String, dynamic>.from(response as Map);
  }

  Future<List<OrderModel>> fetchOrders() async {
    final response = await _supabase
        .from('orders')
        .select('*, profiles(email), order_items(*)')
        .order('created_at', ascending: false);

    return (response as List).map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    await _supabase.from('orders').update({'status': status}).eq('id', orderId);
  }
}
