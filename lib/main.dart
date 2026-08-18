import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FruitListPage(),
      routes: [
        GoRoute(
          path: 'fruit/:name',
          builder: (context, state) {
            final fruitName = state.pathParameters['name'] ?? '';
            return FruitDetailPage(fruitName: fruitName);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    const fruits = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];
    return Scaffold(
      appBar: AppBar(title: const Text('Fruit List')),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return ListTile(
            title: Text(fruit[0].toUpperCase() + fruit.substring(1)),
            onTap: () {
              context.go('/fruit/$fruit');
            },
          );
        },
      ),
    );
  }
}

final Map<String, String> fruitIllustrations = {
  'apple': '🍎',
  'banana': '🍌',
  'cherry': '🍒',
  'date': '📅',
  'elderberry': '🫐',
};

class FruitDetailPage extends StatelessWidget {
  final String fruitName;

  const FruitDetailPage({super.key, required this.fruitName});

  @override
  Widget build(BuildContext context) {
    final illustration = fruitIllustrations[fruitName.toLowerCase()] ?? '?';

    return Scaffold(
      appBar: AppBar(
        title: Text(fruitName[0].toUpperCase() + fruitName.substring(1))),

      body: Center(
        child: Text(
          illustration,
          style: const TextStyle(fontSize: 100),
        ),
      ),
    );
  }
}
