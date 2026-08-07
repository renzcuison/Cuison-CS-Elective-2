import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: const InstagramScreen(),
    );
  }
}

class InstagramScreen extends StatelessWidget {
  const InstagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Instagram',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'serif',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border, color: Colors.black),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.8),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFEDA75),
                          Color(0xFFFA7E1E),
                          Color(0xFFD62976),
                          Color(0xFF962FBF),
                          Color(0xFF4F5BD5),
                        ],
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Renzoy',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.black),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFC84D),
                            Color(0xFFFF5BA7),
                            Color(0xFF7A5CFF),
                          ],
                          stops: [0.0, 0.42, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 26),
                        const SizedBox(width: 14),
                        const Icon(Icons.chat_bubble_outline, color: Colors.black, size: 24),
                        const SizedBox(width: 14),
                        Transform.rotate(
                          angle: -0.5,
                          child: const Icon(Icons.send_outlined, color: Colors.black, size: 24),
                        ),
                        const Spacer(),
                        const Icon(Icons.bookmark_border, color: Colors.black, size: 26),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '10547 Likes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
                        children: [
                          TextSpan(
                            text: '@Renzoy  ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: const [
                        _Tag('#lorem'),
                        _Tag('#ipsum'),
                        _Tag('#dolor'),
                        _Tag('#sit'),
                        _Tag('#amet'),
                        _Tag('#consectetur'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.8),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 58,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE8E8E8), width: 1)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.black, size: 28),
            Icon(Icons.search, color: Colors.black, size: 28),
            Icon(Icons.add_box_outlined, color: Colors.black, size: 28),
            Icon(Icons.movie_outlined, color: Colors.black, size: 28),
            CircleAvatar(
              radius: 13,
              backgroundColor: Color(0xFFF2D36B),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF0A66C2),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}