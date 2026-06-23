import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/controllers/start_menu_controller.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/os_windows/browser/browser_controller.dart';
import 'package:portfolio/themes/text_style.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(
      () => Container(
        width: 320,
        decoration: BoxDecoration(
          color: settings.surface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: settings.accentColor.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: settings.accentColor.withValues(alpha: 0.15),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProfile(settings),
            _buildDivider(settings),
            _buildPinnedApps(settings),
            _buildDivider(settings),
            _buildFindMeOn(settings),
            _buildDivider(settings),
            _buildFooter(settings),
          ],
        ),
      ),
    );
  }

  // ─── PROFILE ────────────────────────────────────────────
  Widget _buildProfile(SettingsController settings) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: settings.muted.withValues(alpha: 0.4),
              border: Border.all(
                color: settings.accentColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: Image.asset('assets/logo.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PortfolioData.name,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  PortfolioData.role,
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Online indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF88).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00FF88).withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00FF88),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Online',
                  style: AppTextStyles.label.copyWith(
                    color: const Color(0xFF00FF88),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── PINNED APPS ────────────────────────────────────────
  Widget _buildPinnedApps(SettingsController settings) {
    final apps = [
      _PinnedApp(
        icon: PhosphorIconsRegular.terminalWindow,
        label: 'Terminal',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('terminal');
          Get.find<StartMenuController>().close();
        },
      ),
      _PinnedApp(
        icon: PhosphorIconsRegular.browser,
        label: 'Browser',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('browser');
          Get.find<StartMenuController>().close();
        },
      ),
      _PinnedApp(
        icon: PhosphorIconsRegular.vault,
        label: 'Vault',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('vault');
          Get.find<StartMenuController>().close();
        },
      ),
      _PinnedApp(
        icon: PhosphorIconsRegular.gear,
        label: 'Settings',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('settings');
          Get.find<StartMenuController>().close();
        },
      ),
      _PinnedApp(
        icon: PhosphorIconsRegular.chartLine,
        label: 'Monitor',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('monitor');
          Get.find<StartMenuController>().close();
        },
      ),
      _PinnedApp(
        icon: PhosphorIconsRegular.briefcase,
        label: 'Cases',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('casestudy');
          Get.find<StartMenuController>().close();
        },
      ),
      _PinnedApp(
        icon: PhosphorIconsRegular.timer,
        label: 'Timeline',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('timeline');
          Get.find<StartMenuController>().close();
        },
      ),
      _PinnedApp(
        icon: PhosphorIconsRegular.code,
        label: 'Env',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('env');
          Get.find<StartMenuController>().close();
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'PINNED',
              style: AppTextStyles.label.copyWith(
                color: Colors.white30,
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
          ),
          // 4-column grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1.1,
            physics: const NeverScrollableScrollPhysics(),
            children: apps
                .map((app) => _PinnedAppButton(app: app, settings: settings))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── FIND ME ON ─────────────────────────────────────────
  Widget _buildFindMeOn(SettingsController settings) {
    final links = [
      _SocialLink(
        icon: PhosphorIconsRegular.filePdf,
        label: 'CV',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('browser');
          Get.find<BrowserController>().openNewTab(title: 'CV', url: 'cv');
          Get.find<StartMenuController>().close();
        },
      ),
      _SocialLink(
        icon: PhosphorIconsRegular.linkedinLogo,
        label: 'LinkedIn',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('browser');
          Get.find<BrowserController>().openNewTab(
            title: 'LinkedIn',
            url: 'linkedin',
          );
          Get.find<StartMenuController>().close();
        },
      ),
      _SocialLink(
        icon: PhosphorIconsRegular.githubLogo,
        label: 'GitHub',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('browser');
          Get.find<BrowserController>().openNewTab(
            title: 'GitHub',
            url: 'github',
          );
          Get.find<StartMenuController>().close();
        },
      ),
      _SocialLink(
        icon: PhosphorIconsRegular.handCoins,
        label: 'Fiverr',
        onTap: () {
          Get.find<DesktopController>().toggleWindow('browser');
          Get.find<BrowserController>().openNewTab(
            title: 'Fiverr',
            url: 'fiverr',
          );
          Get.find<StartMenuController>().close();
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'FIND ME ON',
              style: AppTextStyles.label.copyWith(
                color: Colors.white30,
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Row(
            children: links
                .map(
                  (link) => Expanded(
                    child: _SocialLinkButton(link: link, settings: settings),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── FOOTER ─────────────────────────────────────────────
  Widget _buildFooter(SettingsController settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tiaan Bothma OS',
            style: AppTextStyles.label.copyWith(
              color: Colors.white24,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              color: settings.accentColor.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          Text(
            PortfolioData.version,
            style: AppTextStyles.label.copyWith(
              color: settings.accentColor.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(SettingsController settings) {
    return Divider(
      height: 1,
      thickness: 1,
      color: settings.accentColor.withValues(alpha: 0.15),
    );
  }
}

// ─── PINNED APP DATA ────────────────────────────────────────
class _PinnedApp {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PinnedApp({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

// ─── PINNED APP BUTTON ──────────────────────────────────────
class _PinnedAppButton extends StatefulWidget {
  final _PinnedApp app;
  final SettingsController settings;
  const _PinnedAppButton({required this.app, required this.settings});

  @override
  State<_PinnedAppButton> createState() => _PinnedAppButtonState();
}

class _PinnedAppButtonState extends State<_PinnedAppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.app.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.settings.accentColor.withValues(alpha: 0.18)
                : widget.settings.surface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? widget.settings.accentColor.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.app.icon,
                color: _hovered ? Colors.white : Colors.white60,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                widget.app.label,
                style: AppTextStyles.label.copyWith(
                  color: _hovered ? Colors.white : Colors.white54,
                  fontSize: 9,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── SOCIAL LINK DATA ───────────────────────────────────────
class _SocialLink {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

// ─── SOCIAL LINK BUTTON ─────────────────────────────────────
class _SocialLinkButton extends StatefulWidget {
  final _SocialLink link;
  final SettingsController settings;
  const _SocialLinkButton({required this.link, required this.settings});

  @override
  State<_SocialLinkButton> createState() => _SocialLinkButtonState();
}

class _SocialLinkButtonState extends State<_SocialLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.link.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.settings.accentColor.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _hovered
                    ? widget.settings.accentColor.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  widget.link.icon,
                  color: _hovered ? Colors.white : Colors.white60,
                  size: 18,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.link.label,
                  style: AppTextStyles.label.copyWith(
                    color: _hovered ? Colors.white : Colors.white38,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
