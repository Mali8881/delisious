import 'package:flutter/material.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {

  final List<Product> _products = [
    // Мясные блюда
    Product(id: 1, categoryId: 1, name: 'Котлеты с пюре', description: 'Домашние котлеты с картошкой', price: 520, imageUrl: 'https://i.pinimg.com/736x/9a/e9/1a/9ae91a52614779b50e33941ca56349b6.jpg'),
    Product(id: 2, categoryId: 1, name: 'Говяжьи медальоны', description: 'Сочные кусочки говядины', price: 890, imageUrl:  'https://i.pinimg.com/736x/c6/8b/ba/c68bba1b76f3f656fb55e96c9102588c.jpg'),
    Product(id: 3, categoryId: 1, name: 'Шашлык из баранины', description: 'Классический шашлык', price: 760, imageUrl: 'https://i.imgur.com/shashlik.png'),
    Product(id: 4, categoryId: 1, name: 'Куриные крылышки', description: 'Пикантные крылышки', price: 450, imageUrl: 'https://i.pinimg.com/736x/43/76/a5/4376a500e9361d6e359fe601a7cc11cc.jpg'),
    Product(id: 5, categoryId: 1, name: 'Говядина по-азиатски', description: 'Говядина с соусом', price: 820, imageUrl: 'https://i.pinimg.com/736x/aa/b7/9e/aab79ec6c1404dfa6860006460251146.jpg'),
    Product(id: 6, categoryId: 1, name: 'Стейк рибай', description: 'Сочный стейк средней прожарки', price: 1350, imageUrl: 'https://i.pinimg.com/736x/6f/52/da/6f52da0117af4a69f7197c6427ab17e7.jpg'),

    // Десерты
    Product(id: 7, categoryId: 2, name: 'Тирамису', description: 'Итальянский десерт с кофе', price: 340, imageUrl: 'https://i.pinimg.com/736x/32/1c/64/321c64a91db8ef9666696a64dcd6877b.jpg'),
    Product(id: 8, categoryId: 2, name: 'Чизкейк', description: 'Классический чизкейк', price: 320, imageUrl: 'https://i.pinimg.com/736x/50/c1/72/50c172766cd6a43658484a72ce0a5a3a.jpg'),
    Product(id: 9, categoryId: 2, name: 'Эклер', description: 'С кремом', price: 280, imageUrl: 'https://i.pinimg.com/736x/7d/ec/93/7dec93562c94cc3fa517626ce5ad5d12.jpg'),
    Product(id: 10, categoryId: 2, name: 'Фондан', description: 'С жидким шоколадом', price: 360, imageUrl: 'https://i.pinimg.com/736x/6e/34/4d/6e344d3d63c71beb5dfdf8cc57a40086.jpg'),
    Product(id: 11, categoryId: 2, name: 'Пахлава', description: 'Слоёное тесто с орехами', price: 300, imageUrl: 'https://i.pinimg.com/736x/62/53/4b/62534ba7906355904268803628dd0e85.jpg'),
    Product(id: 12, categoryId: 2, name: 'Клубничный мусс', description: 'Лёгкий ягодный мусс', price: 310, imageUrl: 'https://i.pinimg.com/736x/a3/c0/a4/a3c0a4205f3aae0f9a28857cdc178c38.jpg'),

    // Паста
    Product(id: 13, categoryId: 3, name: 'Паста Карбонара', description: 'Со сливками и беконом', price: 650, imageUrl: 'https://i.pinimg.com/736x/35/ee/c4/35eec4557d610d4fd10e62863aacd085.jpg'),
    Product(id: 14, categoryId: 3, name: 'Паста Болоньезе', description: 'С мясным соусом', price: 640, imageUrl: 'https://i.pinimg.com/736x/91/03/0d/91030d5e1ef99bd9c5ce1289e3679443.jpg'),
    Product(id: 15, categoryId: 3, name: 'Паста с грибами', description: 'С белыми грибами', price: 600, imageUrl: 'https://i.pinimg.com/736x/6a/03/ac/6a03ac4c1f73db1f72119d04edf56bd9.jpg'),
    Product(id: 16, categoryId: 3, name: 'Паста с томатами', description: 'С базиликом и томатами', price: 580, imageUrl: 'https://i.pinimg.com/736x/3e/ce/c1/3ecec16a7cf3a835da5236c8a9879eda.jpg'),
    Product(id: 17, categoryId: 3, name: 'Паста с морепродуктами', description: 'Креветки, кальмары', price: 710, imageUrl: 'https://i.pinimg.com/736x/94/54/d9/9454d95af20e977fad934cf8e4429a58.jpg'),
    Product(id: 18, categoryId: 3, name: 'Лазанья', description: 'Сыр, томатный соус', price: 700, imageUrl: 'https://i.pinimg.com/736x/e9/f7/a2/e9f7a25dc8107224387455a425b94ab0.jpg'),

    // Супы
    Product(id: 19, categoryId: 4, name: 'Борщ', description: 'Классический со сметаной', price: 290, imageUrl: 'https://i.pinimg.com/736x/7a/f4/d1/7af4d1b60a664ecf31b5aeb67db7b863.jpg'),
    Product(id: 20, categoryId: 4, name: 'Солянка', description: 'Мясная сборная', price: 340, imageUrl: 'https://i.pinimg.com/736x/07/e5/17/07e51744358ac224c5ada02d7d9d9047.jpg'),
    Product(id: 21, categoryId: 4, name: 'Окрошка', description: 'Холодный суп', price: 260, imageUrl: 'https://i.pinimg.com/736x/60/bd/10/60bd1099b6505f8dadb260239be51959.jpg'),
    Product(id: 22, categoryId: 4, name: 'Куриный суп', description: 'На бульоне с лапшой', price: 280, imageUrl: 'https://i.pinimg.com/736x/60/bd/10/60bd1099b6505f8dadb260239be51959.jpg'),
    Product(id: 23, categoryId: 4, name: 'Крем-суп из грибов', description: 'Сливочный суп', price: 330, imageUrl: 'https://i.pinimg.com/736x/20/f6/83/20f683b0cfd2b22b72be7a815175e96d.jpg'),
    Product(id: 24, categoryId: 4, name: 'Суп харчо', description: 'Грузинский острый суп', price: 310, imageUrl: 'https://i.pinimg.com/736x/20/f6/83/20f683b0cfd2b22b72be7a815175e96d.jpg'),

    // Салаты
    Product(id: 25, categoryId: 5, name: 'Цезарь', description: 'С курицей и соусом', price: 410, imageUrl: 'https://i.pinimg.com/736x/f5/61/e9/f561e9000172cf30c2370e9a668576a9.jpg'),
    Product(id: 26, categoryId: 5, name: 'Греческий', description: 'Сыр фета и оливки', price: 390, imageUrl: 'https://i.pinimg.com/736x/0a/04/b8/0a04b8615bc0e59fefe92e98529eb114.jpg'),
    Product(id: 27, categoryId: 5, name: 'Оливье', description: 'С колбасой и майонезом', price: 350, imageUrl: 'https://i.pinimg.com/736x/10/0b/5e/100b5e5d19ef122b83e8ec0c9dab7ba7.jpg'),
    Product(id: 28, categoryId: 5, name: 'Винегрет', description: 'Свекла, картошка, огурцы', price: 320, imageUrl: 'https://i.pinimg.com/736x/10/0b/5e/100b5e5d19ef122b83e8ec0c9dab7ba7.jpg'),
    Product(id: 29, categoryId: 5, name: 'Тёплый салат с говядиной', description: 'Мясо, овощи', price: 480, imageUrl: 'https://i.pinimg.com/736x/b9/be/dd/b9bedd1c75e195c57916b10981bccdc1.jpg'),
    Product(id: 30, categoryId: 5, name: 'Салат с тунцом', description: 'Консервированный тунец и яйцо', price: 430, imageUrl: 'https://i.pinimg.com/736x/b9/be/dd/b9bedd1c75e195c57916b10981bccdc1.jpg'),

    // Напитки
    Product(id: 31, categoryId: 6, name: 'Морс ягодный', description: 'Освежающий напиток', price: 180, imageUrl: 'https://i.pinimg.com/736x/32/bf/24/32bf247011423975eb94291d2e9c4ad1.jpg'),
    Product(id: 32, categoryId: 6, name: 'Лимонад', description: 'Домашний с мятой', price: 190, imageUrl: 'https://i.pinimg.com/736x/34/9d/ff/349dffc61a428d44862c0e669a52da81.jpg'),
    Product(id: 33, categoryId: 6, name: 'Айран', description: 'Кисломолочный напиток', price: 150, imageUrl: 'https://i.pinimg.com/736x/60/6c/27/606c27732c40ccf5234ef28473405e23.jpg'),
    Product(id: 34, categoryId: 6, name: 'Кофе капучино', description: 'С пенкой', price: 210, imageUrl: 'https://i.pinimg.com/736x/97/71/4a/97714a280e8f8e1240ab0b957521ad76.jpg'),
    Product(id: 35, categoryId: 6, name: 'Чай зелёный', description: 'С жасмином', price: 160, imageUrl: 'https://i.pinimg.com/736x/97/71/4a/97714a280e8f8e1240ab0b957521ad76.jpg'),
    Product(id: 36, categoryId: 6, name: 'Апельсиновый сок', description: 'Свежевыжатый', price: 230, imageUrl: 'https://i.pinimg.com/736x/bb/db/75/bbdb75f4ba04f950bfae5db632c309b8.jpg'),

    // Выпечка
    Product(id: 37, categoryId: 7, name: 'Хачапури по-аджарски', description: 'Сыр, яйцо, тесто', price: 350, imageUrl: 'https://i.pinimg.com/736x/0d/27/34/0d273475dd8c0a4f8dce46a0099703c0.jpg'),
    Product(id: 38, categoryId: 7, name: 'Круассан', description: 'С маслом', price: 180, imageUrl: 'https://i.pinimg.com/736x/0d/27/34/0d273475dd8c0a4f8dce46a0099703c0.jpg'),
    Product(id: 39, categoryId: 7, name: 'Булочка с корицей', description: 'Пышная и ароматная', price: 190, imageUrl: 'https://i.pinimg.com/736x/65/b0/14/65b014c502ef7fcb20f90d8cafdb3e6b.jpg'),
    Product(id: 40, categoryId: 7, name: 'Пирог с яблоками', description: 'Домашний, тёплый', price: 300, imageUrl: 'hhttps://i.pinimg.com/736x/95/58/6f/95586fe5c4649a3f185098e3c4b782f4.jpg'),
    Product(id: 41, categoryId: 7, name: 'Слойка с сыром', description: 'Сыр внутри', price: 240, imageUrl: 'https://i.pinimg.com/736x/c5/11/ed/c511eda2eae28760d0cbed85ada57590.jpgg'),
    Product(id: 42, categoryId: 7, name: 'Самса', description: 'С мясом', price: 260, imageUrl: 'https://i.pinimg.com/736x/93/68/49/93684930507e2df204e8bc3af4a860b2.jpg'),
  ];



  List<Product> _filteredProducts = [];
  List<Product> get filteredProducts => _filteredProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProductProvider() {
    // Инициализация фильтрацией по первой категории
    filterByCategoryId(1);
  }

  void filterByCategoryId(int id) {
    _filteredProducts = _products.where((product) => product.categoryId == id).toList();
    notifyListeners();
  }

  void searchProducts(String query, List<Category> categories) {
    final lowerQuery = query.toLowerCase();

    _filteredProducts = _products.where((product) {
      final matchesName = product.name.toLowerCase().contains(lowerQuery);
      final categoryName = categories
          .firstWhere((c) => c.id == product.categoryId, orElse: () => Category(id: 0, name: '', imageUrl: ''))
          .name
          .toLowerCase();
      final matchesCategory = categoryName.contains(lowerQuery);

      return matchesName || matchesCategory;
    }).toList();

    notifyListeners();
  }

  void loadProducts({required int categoryId}) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Имитация загрузки
    Future.delayed(const Duration(seconds: 1), () {
      try {
        _filteredProducts = _products.where((product) => product.categoryId == categoryId).toList();
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _isLoading = false;
        _errorMessage = 'Ошибка при загрузке данных';
        notifyListeners();
      }
    });
  }
}
