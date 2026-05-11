import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/controllers/start_menu_controller.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';

class Taskbar extends StatelessWidget {
  const Taskbar({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(() {
      final isLeft = settings.dockPosition.value == 'left';

      return SizedBox(
        width: isLeft ? 70 : double.infinity,
        height: isLeft ? double.infinity : 60,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: isLeft ? 70 : double.infinity,
              height: isLeft ? double.infinity : 60,
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                horizontal: isLeft ? 0 : 16,
                vertical: isLeft ? 16 : 0,
              ),
              child: isLeft
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _LogoButton(),
                        const SizedBox(height: 8),
                        _DockIcon(
                          icon: PhosphorIconsBold.terminalWindow,
                          label: 'Terminal',
                          onTap: () => Get.find<DesktopController>()
                              .toggleWindow('terminal'),
                        ),
                        _DockIcon(
                          icon: PhosphorIconsBold.browser,
                          label: 'Browser',
                          onTap: () => Get.find<DesktopController>()
                              .toggleWindow('browser'),
                        ),
                        _DockIcon(
                          icon: PhosphorIconsRegular.vault,
                          label: 'Vault',
                          onTap: () => Get.find<DesktopController>()
                              .toggleWindow('vault'),
                        ),
                        _DockIcon(
                          icon: PhosphorIconsRegular.gear,
                          label: 'Settings',
                          onTap: () => Get.find<DesktopController>()
                              .toggleWindow('settings'),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const _LogoButton(),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _DockIcon(
                              icon: PhosphorIconsBold.terminalWindow,
                              label: 'Terminal',
                              onTap: () => Get.find<DesktopController>()
                                  .toggleWindow('terminal'),
                            ),
                            _DockIcon(
                              icon: PhosphorIconsBold.browser,
                              label: 'Browser',
                              onTap: () => Get.find<DesktopController>()
                                  .toggleWindow('browser'),
                            ),
                            _DockIcon(
                              icon: PhosphorIconsRegular.vault,
                              label: 'Vault',
                              onTap: () => Get.find<DesktopController>()
                                  .toggleWindow('vault'),
                            ),
                            _DockIcon(
                              icon: PhosphorIconsRegular.gear,
                              label: 'Settings',
                              onTap: () => Get.find<DesktopController>()
                                  .toggleWindow('settings'),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
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
        onTap: () => startMenu.toggle(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.blue.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset('assets/logo.png', width: 45, height: 45),
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
    final settings = Get.find<SettingsController>();

    return Obx(() {
      final isLeft = settings.dockPosition.value == 'left';
      final showLabels = settings.showDockLabels.value;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLeft ? 0 : 10,
          vertical: isLeft ? 8 : 0,
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                if (showLabels) ...[
                  const SizedBox(height: 2),
                  Text(label, style: AppTextStyles.label),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
