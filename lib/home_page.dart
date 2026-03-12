import 'package:flutter/material.dart';
import 'package:portfolio/widgets/main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Stack(
        children: [
          // Wallpaper
          Positioned.fill(
            child: Image.asset(
              'assets/windows_11_wallpaper.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
