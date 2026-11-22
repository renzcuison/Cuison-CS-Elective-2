import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  return ref.read(orderServiceProvider).fetchOrders();
});
