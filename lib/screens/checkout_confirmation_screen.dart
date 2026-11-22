import 'package:flutter/material.dart';

import 'order_history_screen.dart';

class CheckoutConfirmationScreen extends StatelessWidget {
  final int orderId;
  final double totalAmount;

  const CheckoutConfirmationScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF16A34A),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Order confirmed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Order #$orderId · Total paid: \$${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 15, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF18181B),
                  ),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  ),
                  child: const Text('View order history'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to store'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
