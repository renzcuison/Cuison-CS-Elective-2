import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/order_provider.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    const statuses = ['pending', 'processing', 'done', 'cancelled'];

    return Scaffold(
      appBar: AppBar(title: const Text('All orders')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading orders: $err')),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No customer orders yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xFFE4E4E7)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.id}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          DropdownButton<String>(
                            value: statuses.contains(order.status)
                                ? order.status
                                : 'done',
                            underline: const SizedBox(),
                            items: statuses
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (newStatus) async {
                              if (newStatus != null) {
                                await ref
                                    .read(orderServiceProvider)
                                    .updateOrderStatus(order.id, newStatus);
                                ref.invalidate(ordersProvider);
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Customer: ${order.customerEmail ?? order.userId}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF71717A),
                        ),
                      ),
                      const Divider(height: 16),
                      ...order.items.map(
                        (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${i.quantity}× ${i.productName}'),
                              Text('\$${i.subtotal.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
