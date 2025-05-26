import 'package:flutter/material.dart';
import '../../../../data/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final List<Category> _categories = [
    Category(id: 1, name: 'Мясные блюда', imageUrl: 'https://i.pinimg.com/736x/e3/9e/ee/e39eeee05828de84e57ef9a6dbe43b0c.jpg'),
    Category(id: 2, name: 'Десерты', imageUrl: 'https://i.pinimg.com/736x/df/e1/8d/dfe18d5485173070da3a07bc8106c54c.jpg'),
    Category(id: 3, name: 'Паста', imageUrl: 'https://i.pinimg.com/736x/23/e6/6d/23e66d490383247088f31b08ed91719d.jpg'),
    Category(id: 4, name: 'Супы', imageUrl: 'https://i.pinimg.com/736x/8b/74/23/8b74232933db49b297b6d67fb82cbdbc.jpg'),
    Category(id: 5, name: 'Салаты', imageUrl: 'https://i.pinimg.com/736x/8b/74/23/8b74232933db49b297b6d67fb82cbdbc.jpg'),
    Category(id: 6, name: 'Напитки', imageUrl: 'https://i.pinimg.com/736x/8b/74/23/8b74232933db49b297b6d67fb82cbdbc.jpg'),
    Category(id: 7, name: 'Выпечка', imageUrl: 'https://i.pinimg.com/736x/9a/34/78/9a3478d14d4912de672a7b9f4a6e2118.jpg'),
  ];


  int _selectedCategoryId = 1;

  List<Category> get categories => _categories;
  int get selectedCategoryId => _selectedCategoryId;

  bool get isLoading => false;
  String? get errorMessage => null;

  void selectCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  void loadCategories() {
    // Ничего не загружаем, просто имитация
    notifyListeners();
  }
}
