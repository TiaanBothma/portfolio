import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/window_state.dart';
import 'package:portfolio/themes/text_style.dart';

class Taskbar extends StatelessWidget {
  const Taskbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DesktopController>();

    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _DockIcon(
            icon: PhosphorIconsBold.terminalWindow,
            label: 'Terminal',
            onTap: controller.toggleTerminal,
          ),
          _DockIcon(
            icon: PhosphorIconsBold.browser,
            label: 'Browser',
            onTap: () {
              Get.find<DesktopController>().toggleWindow('browser');
            },
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DockIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 2),
              Text(label, style: AppTextStyles.label),
            ],
          ),
        ),
      ),
    );
  }
}
