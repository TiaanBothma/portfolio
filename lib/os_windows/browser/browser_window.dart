// os_windows/browser/browser_window.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/window_state.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'browser_controller.dart';

class BrowserWindow extends StatelessWidget {
  const BrowserWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.92),
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
            GestureDetector(
              onTap: () => desktop.toggleWindow('browser'),
              child: const Icon(
                PhosphorIconsRegular.x,
                color: Colors.white54,
                size: 14,
              ),
            ),
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
                  final isActive = tab.id == browser.activeTabId.value;

                  return GestureDetector(
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
                                color: isActive ? Colors.white : Colors.white54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => browser.closeTab(tab.id),
                            child: const Icon(
                              PhosphorIconsRegular.x,
                              color: Colors.white38,
                              size: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // New tab button
            GestureDetector(
              onTap: () => browser.openNewTab(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  PhosphorIconsRegular.plus,
                  color: Colors.white54,
                  size: 16,
                ),
              ),
            ),
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
            // Back button (placeholder for now)
            Icon(
              PhosphorIconsRegular.arrowLeft,
              color: Colors.white38,
              size: 16,
            ),
            const SizedBox(width: 8),
            Icon(
              PhosphorIconsRegular.arrowRight,
              color: Colors.white38,
              size: 16,
            ),
            const SizedBox(width: 8),
            Icon(
              PhosphorIconsRegular.arrowClockwise,
              color: Colors.white38,
              size: 16,
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
          return const _HomePagePlaceholder();
        default:
          return Center(child: Text('Page: $url', style: AppTextStyles.body));
      }
    });
  }
}

class _HomePagePlaceholder extends StatelessWidget {
  const _HomePagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Browser Home — coming soon', style: AppTextStyles.body),
    );
  }
}
