import 'package:flutter/material.dart';
import 'package:portfolio/themes/colors.dart';

class Taskbar extends StatelessWidget {
  const Taskbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.deepBlue.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.house, color: Colors.white, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}
