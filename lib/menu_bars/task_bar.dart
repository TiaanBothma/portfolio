import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/start_menu_controller.dart';
import 'package:portfolio/controllers/window_state.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/start_menu.dart';

class Taskbar extends StatelessWidget {
  const Taskbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.3),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const _LogoButton(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DockIcon(
                      icon: PhosphorIconsBold.terminalWindow,
                      label: 'Terminal',
                      onTap: () => Get.find<DesktopController>().toggleWindow(
                        'terminal',
                      ),
                    ),
                    _DockIcon(
                      icon: PhosphorIconsBold.browser,
                      label: 'Browser',
                      onTap: () =>
                          Get.find<DesktopController>().toggleWindow('browser'),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          // Start menu popup
          Obx(() {
            final startMenu = Get.find<StartMenuController>();
            if (!startMenu.isOpen.value) return const SizedBox.shrink();
            return Positioned(bottom: 64, left: 8, child: StartMenu());
          }),
        ],
      ),
    );
  }
}

class _LogoButton extends StatefulWidget {
  const _LogoButton();

  @override
  State<_LogoButton> createState() => _LogoButtonState();
}

class _LogoButtonState extends State<_LogoButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final startMenu = Get.find<StartMenuController>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: startMenu.toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.blue.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset('assets/logo.png', width: 40, height: 40),
        ),
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
