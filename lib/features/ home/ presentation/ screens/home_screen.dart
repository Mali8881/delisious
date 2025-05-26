import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../application/category_provider.dart';
import '../application/product_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    categoryProvider.loadCategories();
    productProvider.loadProducts(categoryId: categoryProvider.selectedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню бубликов'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Поисковая строка
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: CustomSearchBar(
              hintText: 'Поиск по блюдам или категориям...',
              onChanged: (query) {
                productProvider.searchProducts(query, categoryProvider.categories);
              },
            ),
          ),

          // Категории
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                final isSelected = category.id == categoryProvider.selectedCategoryId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CategoryChip(
                    category: category,
                    isSelected: isSelected,
                    onTap: () {
                      categoryProvider.selectCategory(category.id);
                      productProvider.filterByCategoryId(category.id);
                    },
                  ),
                );
              },
            ),
          ),

          // Список продуктов
          Expanded(
            child: productProvider.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : productProvider.errorMessage != null
                ? Center(child: Text('Ошибка: ${productProvider.errorMessage}'))
                : productProvider.filteredProducts.isEmpty
                ? const Center(child: Text('Бублики не найдены'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: productProvider.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = productProvider.filteredProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
