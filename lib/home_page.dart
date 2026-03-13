import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/window_state.dart';
import 'package:portfolio/os_windows/terminal/terminal_window.dart';
import 'package:portfolio/widgets/drag_resize_window.dart';
import 'package:portfolio/widgets/main_layout.dart';
import 'package:portfolio/widgets/status_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.find<DesktopController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/wallpaper.png', fit: BoxFit.cover),
        ),
        const Positioned(top: 40, left: 20, child: StatusCard()),
        MainLayout(
          child: Stack(
            children: [
              Obx(
                () => controller.terminalOpen
                    ? DraggableResizableWindow(
                        windowId: 'terminal',
                        minWidth: 400,
                        minHeight: 250,
                        child: const TerminalWindow(),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
