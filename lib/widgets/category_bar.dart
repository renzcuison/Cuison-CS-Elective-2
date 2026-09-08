import 'package:flutter/material.dart';

class CategoryBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onSelectCategory;

  const CategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = cat == selectedCategory;
            return GestureDetector(
              onTap: () => onSelectCategory(cat),
              child: Container(
                margin: const EdgeInsets.only(right: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(cat),
                      size: 32,
                      color: isSelected
                          ? colorScheme.secondary
                          : colorScheme.primary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.secondary
                            : colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'iPhone':
        return Icons.phone_iphone;
      case 'Mac':
        return Icons.laptop;
      case 'iPad':
        return Icons.tablet_mac;
      case 'Watch':
        return Icons.watch;
      case 'Audio':
        return Icons.headphones;
      case 'Accessories':
        return Icons.devices_other;
      default:
        return Icons.storefront;
    }
  }
}
