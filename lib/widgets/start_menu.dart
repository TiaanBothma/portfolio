import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/start_menu_controller.dart';
import 'package:portfolio/controllers/window_state.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/os_windows/browser/browser_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProfile(),
          _buildDivider(),
          _buildSection('QUICK LAUNCH', [
            _buildItem(
              icon: PhosphorIconsRegular.terminalWindow,
              label: 'Terminal',
              onTap: () {
                Get.find<DesktopController>().toggleWindow('terminal');
                Get.find<StartMenuController>().close();
              },
            ),
            _buildItem(
              icon: PhosphorIconsRegular.browser,
              label: 'Browser',
              onTap: () {
                Get.find<DesktopController>().toggleWindow('browser');
                Get.find<StartMenuController>().close();
              },
            ),
          ]),
          _buildDivider(),
          _buildSection('FIND ME ON', [
            _buildItem(
              icon: PhosphorIconsRegular.linkedinLogo,
              label: 'LinkedIn',
              onTap: () {
                final desktop = Get.find<DesktopController>();
                final browser = Get.find<BrowserController>();
                desktop.toggleWindow('browser');
                browser.openNewTab(title: 'LinkedIn', url: 'linkedin');
                Get.find<StartMenuController>().close();
              },
            ),
            _buildItem(
              icon: PhosphorIconsRegular.githubLogo,
              label: 'GitHub',
              onTap: () {
                final desktop = Get.find<DesktopController>();
                final browser = Get.find<BrowserController>();
                desktop.toggleWindow('browser');
                browser.openNewTab(title: 'GitHub', url: 'github');
                Get.find<StartMenuController>().close();
              },
            ),
            _buildItem(
              icon: PhosphorIconsRegular.handCoins,
              label: 'Fiverr',
              onTap: () {
                final desktop = Get.find<DesktopController>();
                final browser = Get.find<BrowserController>();
                desktop.toggleWindow('browser');
                browser.openNewTab(title: 'Fiverr', url: 'fiverr');
                Get.find<StartMenuController>().close();
              },
            ),
          ]),
          _buildDivider(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.purple.withValues(alpha: 0.4),
              border: Border.all(
                  color: AppColors.blue.withValues(alpha: 0.5), width: 1),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(PortfolioData.name,
                  style: AppTextStyles.body.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(PortfolioData.role,
                  style: AppTextStyles.label.copyWith(color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(title,
                style: AppTextStyles.label.copyWith(
                    color: Colors.white30,
                    fontSize: 10,
                    letterSpacing: 1.5)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _StartMenuItem(icon: icon, label: label, onTap: onTap);
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.blue.withValues(alpha: 0.2),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tiaan Bothma OS',
            style: AppTextStyles.label.copyWith(
                color: Colors.white24, fontSize: 11, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _StartMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _StartMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_StartMenuItem> createState() => _StartMenuItemState();
}

class _StartMenuItemState extends State<_StartMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: _hovered
              ? AppColors.blue.withValues(alpha: 0.2)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(widget.icon,
                  color: _hovered ? Colors.white : Colors.white60, size: 16),
              const SizedBox(width: 12),
              Text(widget.label,
                  style: AppTextStyles.body.copyWith(
                      color: _hovered ? Colors.white : Colors.white70,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}