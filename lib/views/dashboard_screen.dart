import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/dashboard_layout.dart';
import 'widgets/navigation_sidebar.dart';

class ResponsiveAdaptiveDashboard extends StatelessWidget {
  const ResponsiveAdaptiveDashboard({super.key});

  bool get _isIOS => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (_isIOS) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('responsivedashboard'),
        ),
        child: SafeArea(
          child: DashboardLayout(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('responsivedashboard'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      drawer: LayoutBuilder(
        builder: (context, constraints) {
          if (MediaQuery.of(context).size.width < 600) {
            return const Drawer(
              child: NavigationSidebar(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: const DashboardLayout(),
    );
  }
}