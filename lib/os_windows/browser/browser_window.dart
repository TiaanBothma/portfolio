import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/os_windows/browser/browser_pages.dart/browser_home_page.dart';
import 'package:portfolio/os_windows/browser/browser_pages.dart/cv_page.dart';
import 'package:portfolio/os_windows/browser/browser_pages.dart/fiverr_page.dart';
import 'package:portfolio/os_windows/browser/browser_pages.dart/github_page.dart';
import 'package:portfolio/os_windows/browser/browser_pages.dart/linkedin_page.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';
import 'browser_controller.dart';

class BrowserWindow extends StatelessWidget {
  const BrowserWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.black.withValues(
            alpha: Get.find<SettingsController>().windowTransparency.value,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.blue.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            _buildTitleBar(),
            _buildTabBar(),
            _buildAddressBar(),
            const Expanded(child: _BrowserContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (details) => desktop.dragWindow('browser', details.delta),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.deepBlue.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('browser', style: AppTextStyles.label),
            MinimizeButton(onTap: () => desktop.toggleWindow('browser')),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final browser = Get.find<BrowserController>();

    return Obx(
      () => Container(
        height: 36,
        color: AppColors.deepBlue.withValues(alpha: 0.6),
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: browser.tabs.length,
                itemBuilder: (context, index) {
                  final tab = browser.tabs[index];
                  // Each tab item has its own Obx watching activeTabId
                  return Obx(() {
                    final isActive = tab.id == browser.activeTabId.value;
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => browser.switchTab(tab.id),
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 120,
                            maxWidth: 200,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.black.withValues(alpha: 0.6)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: isActive
                                    ? AppColors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  tab.title,
                                  style: AppTextStyles.label.copyWith(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _CloseTabButton(
                                onTap: () => browser.closeTab(tab.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            _NewTabButton(onTap: () => browser.openNewTab()),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressBar() {
    final browser = Get.find<BrowserController>();

    return Obx(
      () => Container(
        height: 40,
        color: AppColors.black.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Back button — goes to home
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => browser.navigateTo('home', 'New Tab'),
                child: Icon(
                  PhosphorIconsRegular.arrowLeft,
                  color: Colors.white60,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Refresh button — rebuilds current page
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  final current = browser.activeTab;
                  if (current == null) return;
                  final url = current.url;
                  final title = current.title;
                  browser.navigateTo('home', 'Loading...');
                  Future.delayed(const Duration(milliseconds: 100), () {
                    browser.navigateTo(url, title);
                  });
                },
                child: Icon(
                  PhosphorIconsRegular.arrowClockwise,
                  color: Colors.white60,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // URL bar
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.deepBlue.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  browser.activeTab?.url ?? 'home',
                  style: AppTextStyles.label.copyWith(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrowserContent extends StatelessWidget {
  const _BrowserContent();

  @override
  Widget build(BuildContext context) {
    final browser = Get.find<BrowserController>();

    return Obx(() {
      final url = browser.activeTab?.url ?? 'home';

      switch (url) {
        case 'home':
          return const BrowserHomePage();
        case 'github':
          return const GitHubPage();
        case 'linkedin':
          return const LinkedInPage();
        case 'fiverr':
          return const FiverrPage();
        case 'cv':
          return const CvPage();
        default:
          return const BrowserHomePage();
      }
    });
  }
}

class _CloseTabButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CloseTabButton({required this.onTap});

  @override
  State<_CloseTabButton> createState() => _CloseTabButtonState();
}

class _CloseTabButtonState extends State<_CloseTabButton> {
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
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            PhosphorIconsRegular.x,
            color: _hovered ? Colors.white : Colors.white38,
            size: 10,
          ),
        ),
      ),
    );
  }
}

class _NewTabButton extends StatefulWidget {
  final VoidCallback onTap;
  const _NewTabButton({required this.onTap});

  @override
  State<_NewTabButton> createState() => _NewTabButtonState();
}

class _NewTabButtonState extends State<_NewTabButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.blue.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            PhosphorIconsRegular.plus,
            color: _hovered ? Colors.white : Colors.white54,
            size: 16,
          ),
        ),
      ),
    );
  }
}
