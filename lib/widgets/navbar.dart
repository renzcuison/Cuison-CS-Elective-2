import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppleNavBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isMobile;
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onSelectCategory;
  final VoidCallback onToggleTheme;

  const AppleNavBar({
    super.key,
    required this.isMobile,
    required this.selectedCategory,
    required this.categories,
    required this.onSelectCategory,
    required this.onToggleTheme,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.apple, size: 20),
                onPressed: () => onSelectCategory('Store'),
              ),
              const SizedBox(width: 8),

              if (!isMobile)
                ...categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () => onSelectCategory(cat),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                            color: isSelected
                              ? colorScheme.onSurface.withValues(alpha: 0.9)
                              : colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  );
                }),

              const SizedBox(width: 8),

              IconButton(
                icon: Icon(
                  colorScheme.brightness == Brightness.dark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  size: 18,
                ),
                onPressed: onToggleTheme,
              ),

              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                onPressed: () => context.push('/cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
