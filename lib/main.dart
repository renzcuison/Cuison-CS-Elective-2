import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/shop_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oudjauyrkpcubzwmiqtq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91ZGphdXlya3BjdWJ6d21pcXRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQxNTcyOTUsImV4cCI6MjEwOTczMzI5NX0.dpIJM9HaL0sxc7SMureWVugBQqEI_v4ZCKk5ORjzvFI',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ShopScreen(),
    );
  }
}