import 'package:flutter/material.dart';
import 'package:portfolio/menu_bars/task_bar.dart';
import 'package:portfolio/menu_bars/top_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const TopBar(),
          Expanded(child: child),
          const Taskbar(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
