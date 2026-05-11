import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/menu_bars/task_bar.dart';
import 'package:portfolio/menu_bars/top_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(() {
      final isLeft = settings.dockPosition.value == 'left';

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: isLeft
            ? Row(
                children: [
                  const Taskbar(),
                  Expanded(
                    child: Column(
                      children: [
                        const TopBar(),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const TopBar(),
                  Expanded(child: child),
                  const Taskbar(),
                ],
              ),
      );
    });
  }
}
