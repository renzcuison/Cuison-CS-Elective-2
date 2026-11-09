import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/supabase_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final SupabaseService _supabaseService = SupabaseService();

  // Filter State
  RangeValues _priceRange = const RangeValues(0, 300);

  // Pagination State
  int _currentPage = 0;
  final int _itemsPerPage = 6;

  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _supabaseService.fetchProducts(
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        page: _currentPage,
        itemsPerPage: _itemsPerPage,
      );
    });
  }

  void _resetPaginationAndLoad() {
    _currentPage = 0; // Reset to page 1 whenever price filter changes
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop Products'), centerTitle: true),
      body: Column(
        children: [
          // 1. PRICE FILTER SLIDER SECTION
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Range: \$${_priceRange.start.toStringAsFixed(0)} - \$${_priceRange.end.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 300,
                  divisions: 30,
                  labels: RangeLabels(
                    '\$${_priceRange.start.round()}',
                    '\$${_priceRange.end.round()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                  onChangeEnd: (RangeValues values) {
                    _resetPaginationAndLoad();
                  },
                ),
              ],
            ),
          ),

          // 2. PRODUCT LIST & PAGINATION SECTION
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final products = snapshot.data ?? [];

                return Column(
                  children: [
                    // Grid View / Empty State
                    Expanded(
                      child: products.isEmpty
                          ? const Center(
                              child: Text(
                                'No products found in this price range.',
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.85,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return Card(
                                  elevation: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_bag,
                                        size: 48,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        product.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _currentPage > 0
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                    _loadProducts();
                                  }
                                : null,
                            child: const Text('Previous'),
                          ),
                          Text(
                            'Page ${_currentPage + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: products.length == _itemsPerPage
                                ? () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                    _loadProducts();
                                  }
                                : null, 
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
