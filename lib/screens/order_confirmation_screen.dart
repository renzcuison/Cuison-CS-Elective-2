import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/navbar.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const OrderConfirmationScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppleNavBar(
        isMobile: false,
        selectedCategory: 'Store',
        categories: const [
          'Store',
          'iPhone',
          'Mac',
          'iPad',
          'Watch',
          'Audio',
          'Accessories',
        ],
        onSelectCategory: (cat) => context.go('/'),
        onToggleTheme: onToggleTheme,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 90,
                color: AppTheme.successGreen,
              ),
              const SizedBox(height: 24),
              const Text(
                'Thank you for your order.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your order number is #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}.',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.87),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => context.go('/'),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
