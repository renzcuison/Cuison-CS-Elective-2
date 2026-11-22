import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/filter_section.dart';
import '../widgets/pagination_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/product_skeleton.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final _searchController = TextEditingController();
  bool _showFilter = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(catalogFilterProvider);
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Store',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(_showFilter ? Icons.tune : Icons.tune_outlined),
            onPressed: () => setState(() => _showFilter = !_showFilter),
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'My Orders',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
          ),
          Badge(
            label: Text('$cartCount'),
            isLabelVisible: cartCount > 0,
            child: IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              tooltip: 'Cart',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
            onPressed: () async {
              ref.read(cartProvider.notifier).clearCart();
              await ref.read(authServiceProvider).signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: filter.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(catalogFilterProvider.notifier)
                              .setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: const Color(0xFFF4F4F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (val) =>
                  ref.read(catalogFilterProvider.notifier).setSearchQuery(val),
            ),
          ),
          FilterSection(
            isVisible: _showFilter,
            priceRange: filter.priceRange,
            categories: categoriesAsync.value ?? [],
            selectedCategoryId: filter.selectedCategoryId,
            onPriceChanged: (range) =>
                ref.read(catalogFilterProvider.notifier).setPriceRange(range),
            onPriceChangeEnd: (_) => ref.invalidate(productsProvider),
            onCategorySelected: (id) =>
                ref.read(catalogFilterProvider.notifier).setCategory(id),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const ProductSkeleton(),
              error: (err, _) =>
                  Center(child: Text('Error loading catalog: $err')),
              data: (products) => Column(
                children: [
                  Expanded(
                    child: products.isEmpty
                        ? const Center(child: Text('No products found.'))
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
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
                                isAdmin: false,
                                onAddToCart: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addToCart(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added ${product.name} to cart',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  PaginationBar(
                    currentPage: filter.currentPage,
                    hasNextPage: products.length == filter.itemsPerPage,
                    onPrevious: () =>
                        ref.read(catalogFilterProvider.notifier).previousPage(),
                    onNext: () =>
                        ref.read(catalogFilterProvider.notifier).nextPage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
