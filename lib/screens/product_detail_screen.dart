import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/navbar.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final VoidCallback onToggleTheme;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.onToggleTheme,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final product = dummyProducts.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => dummyProducts.first,
    );
    final double monthlyPrice = product.price / 24;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppleNavBar(
            isMobile: isMobile,
            selectedCategory: product.category,
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
            onToggleTheme: widget.onToggleTheme,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.accentOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 36 : 56,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: Image.network(
                    product.imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: colorScheme.onSurface.withValues(alpha: 0.24),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    final existingIndex = globalCart.indexWhere(
                      (item) => item.product.id == product.id,
                    );
                    if (existingIndex >= 0) {
                      globalCart[existingIndex].quantity++;
                    } else {
                      globalCart.add(CartItem(product: product));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to Bag.'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'View Bag',
                          onPressed: () => context.push('/cart'),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Buy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'From ₱${product.price.toStringAsFixed(2)} or ₱${monthlyPrice.toStringAsFixed(2)}/mo. for 24 mo.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      },
    );
  }
}
