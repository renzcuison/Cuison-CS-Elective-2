import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/pagination_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/product_skeleton.dart';
import 'admin_categories_screen.dart';
import 'admin_orders_screen.dart';
import 'product_form_screen.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(productServiceProvider).deleteProduct(product.id);
        ref.invalidate(productsProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(catalogFilterProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin catalog',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Categories',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminCategoriesScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: 'Customer Orders',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
            onPressed: () async => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF18181B),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
      body: productsAsync.when(
        loading: () => const ProductSkeleton(),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (products) => Column(
          children: [
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No products in catalog.'))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.66,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          isAdmin: true,
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductFormScreen(existingProduct: product),
                            ),
                          ),
                          onDelete: () => _confirmDelete(context, ref, product),
                        );
                      },
                    ),
            ),
            PaginationBar(
              currentPage: filter.currentPage,
              hasNextPage: products.length == filter.itemsPerPage,
              onPrevious: () =>
                  ref.read(catalogFilterProvider.notifier).previousPage(),
              onNext: () => ref.read(catalogFilterProvider.notifier).nextPage(),
            ),
          ],
        ),
      ),
    );
  }
}
