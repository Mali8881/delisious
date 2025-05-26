import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/ home/ presentation/ screens/auth_screen.dart';
import 'features/ home/ presentation/ screens/cart_screen.dart';
import 'features/ home/ presentation/ screens/home_screen.dart';
import 'features/ home/ presentation/ screens/login_screen.dart';
import 'features/ home/ presentation/ screens/order_screen.dart';
import 'features/ home/ presentation/ screens/payment_screen.dart';
import 'features/ home/ presentation/ screens/product_details_screen.dart';
import 'features/ home/ presentation/ screens/profile_screen.dart';
import 'features/ home/ presentation/ screens/register_screen.dart';
import 'features/ home/ presentation/application/auth_provider.dart';
import 'features/ home/ presentation/application/cart_provider.dart';
import 'features/ home/ presentation/application/category_provider.dart';
import 'features/ home/ presentation/application/order_provider.dart';
import 'features/ home/ presentation/application/product_provider.dart';
import 'data/models/order.dart';
import 'data/models/product.dart';
import 'firebase_options.dart'; // ✅ важно!

// import 'features/home/presentation/application/auth_provider.dart'; // если есть

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShopM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'SF Pro Display',
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/main': (context) => const MainNavigation(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/payment') {
            final order = settings.arguments as ShopOrder;
            return MaterialPageRoute(
              builder: (context) => PaymentScreen(order: order),
            );
          }
          if (settings.name == '/product-details') {
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            );
          }
          return null;
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Заказы'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
