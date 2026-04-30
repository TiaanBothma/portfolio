// os_windows/browser/browser_pages/browser_home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/os_windows/browser/browser_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';

class BrowserHomePage extends StatefulWidget {
  const BrowserHomePage({super.key});

  @override
  State<BrowserHomePage> createState() => _BrowserHomePageState();
}

class _BrowserHomePageState extends State<BrowserHomePage> {
  String? _hoveredId;

  final List<_PinnedSite> _sites = const [
    _PinnedSite(
      id: 'github',
      label: 'GitHub',
      url: 'github',
      subtitle: 'github.com/TiaanBothma',
      icon: PhosphorIconsBold.githubLogo,
      accentColor: Color(0xFF6E40C9),
    ),
    _PinnedSite(
      id: 'linkedin',
      label: 'LinkedIn',
      url: 'linkedin',
      subtitle: 'linkedin.com/in/tiaan-bothma-0b1bb3283/',
      icon: PhosphorIconsBold.linkedinLogo,
      accentColor: Color(0xFF0A66C2),
    ),
    _PinnedSite(
      id: 'fiverr',
      label: 'Fiverr',
      url: 'fiverr',
      subtitle: 'fiverr.com/s/xX3GEzD',
      icon: PhosphorIconsBold.handCoins,
      accentColor: Color(0xFF1DBF73),
    ),
    _PinnedSite(
      id: 'cv',
      label: 'CV',
      url: 'cv',
      subtitle: 'Download or print my CV',
      icon: PhosphorIconsRegular.filePdf,
      accentColor: Color(0xFF0D00A4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black.withValues(alpha: 0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGreeting(),
          const SizedBox(height: 48),
          _buildPinnedSites(),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      children: [
        Text(
          'Where to?',
          style: AppTextStyles.display.copyWith(
            fontSize: 28,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a pinned site to explore',
          style: AppTextStyles.label.copyWith(
            color: Colors.white38,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPinnedSites() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _sites.map((site) => _buildSiteCard(site)).toList(),
    );
  }

  Widget _buildSiteCard(_PinnedSite site) {
    final isHovered = _hoveredId == site.id;
    final browser = Get.find<BrowserController>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredId = site.id),
      onExit: (_) => setState(() => _hoveredId = null),
      child: GestureDetector(
        onTap: () => browser.openNewTab(title: site.label, url: site.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: isHovered
                ? site.accentColor.withValues(alpha: 0.15)
                : AppColors.deepBlue.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered
                  ? site.accentColor.withValues(alpha: 0.8)
                  : AppColors.blue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isHovered
                      ? site.accentColor.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  site.icon,
                  color: isHovered ? site.accentColor : Colors.white54,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                site.label,
                style: AppTextStyles.body.copyWith(
                  color: isHovered ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                site.subtitle,
                style: AppTextStyles.label.copyWith(
                  color: Colors.white24,
                  fontSize: 10,
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

class _PinnedSite {
  final String id;
  final String label;
  final String url;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _PinnedSite({
    required this.id,
    required this.label,
    required this.url,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}
