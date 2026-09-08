import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../widgets/navbar.dart';
import '../widgets/category_bar.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Store';
  final List<String> _categories = const [
    'Store',
    'iPhone',
    'Mac',
    'iPad',
    'Watch',
    'Audio',
    'Accessories',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == 'Store'
        ? dummyProducts
        : dummyProducts.where((p) => p.category == _selectedCategory).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Scaffold(
          drawer: isMobile ? _buildMobileDrawer(context) : null,
          appBar: AppleNavBar(
            isMobile: isMobile,
            selectedCategory: _selectedCategory,
            categories: _categories,
            onSelectCategory: (cat) => setState(() => _selectedCategory = cat),
            onToggleTheme: widget.onToggleTheme,
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryBar(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onSelectCategory: (cat) =>
                          setState(() => _selectedCategory = cat),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCategory == 'Store'
                                ? 'Store'
                                : _selectedCategory,
                            style: TextStyle(
                              fontSize: isMobile ? 32 : 48,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Explore the lineup.',
                            style: TextStyle(
                              fontSize: isMobile ? 20 : 28,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 2 : 4,
                          childAspectRatio: isMobile ? 0.38 : 0.52,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 28,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push('/product/${product.id}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(Icons.apple, size: 32),
            ),
            const Divider(),
            ..._categories.map(
              (cat) => ListTile(
                title: Text(
                  cat,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedCategory = cat);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
