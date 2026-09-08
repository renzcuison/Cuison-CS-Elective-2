import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'models/product.dart';
import 'screens/order_confirmation_screen.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatefulWidget {
  const ECommerceApp({super.key});

  @override
  State<ECommerceApp> createState() => _ECommerceAppState();
}

class _ECommerceAppState extends State<ECommerceApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(onToggleTheme: _toggleTheme),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'Unknown';
          return ProductDetailScreen(
            productId: id,
            onToggleTheme: _toggleTheme,
          );
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => CartScreen(onToggleTheme: _toggleTheme),
      ),
      GoRoute(
        path: '/confirmation',
        builder: (context, state) =>
            OrderConfirmationScreen(onToggleTheme: _toggleTheme),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) =>
            CheckoutScreen(onToggleTheme: _toggleTheme),
        redirect: (context, state) {
          if (globalCart.isEmpty) {
            return '/cart';
          }
          return null;
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Apple',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
