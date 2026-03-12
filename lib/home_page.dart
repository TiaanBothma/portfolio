import 'package:flutter/material.dart';
import 'package:portfolio/widgets/main_layout.dart';
import 'package:portfolio/widgets/status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //! Keep wallpaper to stack all widgets ontop
        Positioned.fill(
          child: Image.asset('assets/wallpaper.png', fit: BoxFit.cover),
        ),

        Positioned(top: 40, left: 20, child: const StatusCard()),

        const MainLayout(child: SizedBox.expand()),
      ],
    );
  }
}
