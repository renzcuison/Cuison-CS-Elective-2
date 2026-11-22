import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/auth_provider.dart';
import 'screens/admin_home_screen.dart';
import 'screens/customer_home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oudjauyrkpcubzwmiqtq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91ZGphdXlya3BjdWJ6d21pcXRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQxNTcyOTUsImV4cCI6MjEwOTczMzI5NX0.dpIJM9HaL0sxc7SMureWVugBQqEI_v4ZCKk5ORjzvFI',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Storefront',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF18181B),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          foregroundColor: Color(0xFF18181B),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    return profileAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Session error: $err'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.read(authServiceProvider).signOut(),
                child: const Text('Return to login'),
              ),
            ],
          ),
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return const LoginScreen();
        }
        return profile.isAdmin
            ? const AdminHomeScreen()
            : const CustomerHomeScreen();
      },
    );
  }
}
