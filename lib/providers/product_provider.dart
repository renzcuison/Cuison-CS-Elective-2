import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/storage_service.dart';

final productServiceProvider = Provider<ProductService>(
  (ref) => ProductService(),
);
final categoryServiceProvider = Provider<CategoryService>(
  (ref) => CategoryService(),
);
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(categoryServiceProvider).fetchCategories();
});

class CatalogFilterState {
  final RangeValues priceRange;
  final int? selectedCategoryId;
  final String searchQuery;
  final int currentPage;
  final int itemsPerPage;

  const CatalogFilterState({
    this.priceRange = const RangeValues(0, 300),
    this.selectedCategoryId,
    this.searchQuery = '',
    this.currentPage = 0,
    this.itemsPerPage = 6,
  });

  CatalogFilterState copyWith({
    RangeValues? priceRange,
    int? selectedCategoryId,
    bool clearCategory = false,
    String? searchQuery,
    int? currentPage,
  }) {
    return CatalogFilterState(
      priceRange: priceRange ?? this.priceRange,
      selectedCategoryId: clearCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage,
    );
  }
}

class CatalogFilterNotifier extends Notifier<CatalogFilterState> {
  @override
  CatalogFilterState build() => const CatalogFilterState();

  void setPriceRange(RangeValues range) {
    state = state.copyWith(priceRange: range, currentPage: 0);
  }

  void setCategory(int? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearCategory: true, currentPage: 0);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId, currentPage: 0);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 0);
  }

  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }
}

final catalogFilterProvider =
    NotifierProvider<CatalogFilterNotifier, CatalogFilterState>(
      CatalogFilterNotifier.new,
    );

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final filter = ref.watch(catalogFilterProvider);
  return ref
      .read(productServiceProvider)
      .fetchProducts(
        minPrice: filter.priceRange.start,
        maxPrice: filter.priceRange.end,
        page: filter.currentPage,
        itemsPerPage: filter.itemsPerPage,
        categoryId: filter.selectedCategoryId,
        searchQuery: filter.searchQuery,
      );
});
