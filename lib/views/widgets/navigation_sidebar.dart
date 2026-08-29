import 'package:flutter/material.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(
            Icons.favorite,
            size: 48,
            color: Colors.black,
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black87),
            title: const Text('D A S H B O A R D', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black87),
            title: const Text('S E T T I N G S', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.black87),
            title: const Text('A B O U T', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black87),
            title: const Text('L O G O U T', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}