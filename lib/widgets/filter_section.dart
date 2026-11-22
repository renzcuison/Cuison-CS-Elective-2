import 'package:flutter/material.dart';

import '../models/category.dart';

class FilterSection extends StatelessWidget {
  final bool isVisible;
  final RangeValues priceRange;
  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<RangeValues> onPriceChanged;
  final ValueChanged<RangeValues> onPriceChangeEnd;
  final ValueChanged<int?> onCategorySelected;

  const FilterSection({
    super.key,
    required this.isVisible,
    required this.priceRange,
    required this.categories,
    required this.selectedCategoryId,
    required this.onPriceChanged,
    required this.onPriceChangeEnd,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: isVisible ? 156 : 0,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          color: const Color(0xFFFAFAFA),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: selectedCategoryId == null,
                        onSelected: (_) => onCategorySelected(null),
                      ),
                    ),
                    ...categories.map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat.name),
                          selected: selectedCategoryId == cat.id,
                          onSelected: (_) => onCategorySelected(cat.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\$${priceRange.start.round()} – \$${priceRange.end.round()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF18181B),
                  inactiveTrackColor: const Color(0xFFE4E4E7),
                  thumbColor: const Color(0xFF18181B),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                  trackHeight: 2,
                ),
                child: RangeSlider(
                  values: priceRange,
                  min: 0,
                  max: 300,
                  divisions: 30,
                  onChanged: onPriceChanged,
                  onChangeEnd: onPriceChangeEnd,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
