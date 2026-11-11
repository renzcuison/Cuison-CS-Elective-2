import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/supabase_service.dart';
import '../services/auth_service.dart';
import '../widgets/filter_section.dart';
import '../widgets/pagination_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/product_skeleton.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final AuthService _authService = AuthService();

  RangeValues _priceRange = const RangeValues(0, 300);
  bool _showFilter = false;

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
    _currentPage = 0;
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Shop',
          style: TextStyle(
            color: Color(0xFF18181B),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilter ? Icons.tune : Icons.tune_outlined,
              color: const Color(0xFF18181B),
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFF18181B),
              size: 20,
            ),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          FilterSection(
            isVisible: _showFilter,
            priceRange: _priceRange,
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
            onChangeEnd: (RangeValues values) {
              _resetPaginationAndLoad();
            },
          ),

          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProductSkeleton();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Unable to load items: ${snapshot.error}',
                      style: const TextStyle(color: Color(0xFF71717A), fontSize: 13),
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                return Column(
                  children: [
                    Expanded(
                      child: products.isEmpty
                          ? const Center(
                              child: Text(
                                'No products found in this price range.',
                                style: TextStyle(color: Color(0xFF71717A), fontSize: 14),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.68,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 24,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: products[index],
                                  onTap: () {},
                                );
                              },
                            ),
                    ),

                    PaginationBar(
                      currentPage: _currentPage,
                      hasNextPage: products.length == _itemsPerPage,
                      onPrevious: () {
                        setState(() {
                          _currentPage--;
                        });
                        _loadProducts();
                      },
                      onNext: () {
                        setState(() {
                          _currentPage++;
                        });
                        _loadProducts();
                      },
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