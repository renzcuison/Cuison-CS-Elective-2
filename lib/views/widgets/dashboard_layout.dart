import 'package:flutter/material.dart';
import '../layouts/mobile_layout.dart';
import '../layouts/tablet_layout.dart';
import '../layouts/desktop_layout.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return const DesktopLayout();
        } else if (constraints.maxWidth >= 600) {
          return const TabletLayout();
        } else {
          return const MobileLayout();
        }
      },
    );
  }
}