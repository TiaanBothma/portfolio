import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';

class SettingsWindow extends StatelessWidget {
  const SettingsWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: double.infinity,
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('APPEARANCE'),
                    const SizedBox(height: 12),
                    _buildWallpaperSection(),
                    const SizedBox(height: 24),
                    _buildAccentColorSection(),
                    const SizedBox(height: 24),
                    _buildTransparencySection(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('SYSTEM'),
                    const SizedBox(height: 12),
                    _buildClockSection(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('TERMINAL'),
                    const SizedBox(height: 12),
                    _buildCursorSection(),
                    const SizedBox(height: 32),
                    _buildResetButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TITLE BAR ──────────────────────────────────────────
  Widget _buildTitleBar() {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (d) => desktop.dragWindow('settings', d.delta),
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
            Row(
              children: [
                Icon(
                  PhosphorIconsRegular.gear,
                  color: Colors.white54,
                  size: 13,
                ),
                const SizedBox(width: 8),
                Text('settings', style: AppTextStyles.label),
              ],
            ),
            MinimizeButton(onTap: () => desktop.toggleWindow('settings')),
          ],
        ),
      ),
    );
  }

  // ─── SECTION LABEL ──────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.label.copyWith(
        color: Colors.white30,
        fontSize: 10,
        letterSpacing: 1.5,
      ),
    );
  }

  // ─── WALLPAPER ──────────────────────────────────────────
  Widget _buildWallpaperSection() {
    final settings = Get.find<SettingsController>();

    return _settingsCard(
      icon: PhosphorIconsRegular.image,
      title: 'Wallpaper',
      child: Obx(
        () => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: SettingsController.wallpapers.map((w) {
            final isSelected = settings.wallpaper.value == w['id'];
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => settings.setWallpaper(w['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? settings.accentColor : Colors.white24,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preview
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7),
                        ),
                        child: SizedBox(
                          height: 70,
                          child: _wallpaperPreview(
                            w['id'] as String,
                            settings.accentColor,
                          ),
                        ),
                      ),
                      // Label
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    w['label'] as String,
                                    style: AppTextStyles.label.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (w['isLive'] as bool)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: settings.accentColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      'LIVE',
                                      style: AppTextStyles.label.copyWith(
                                        color: settings.accentColor,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              w['description'] as String,
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white30,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _wallpaperPreview(String id, Color accent) {
    switch (id) {
      case 'neural':
        return Container(
          color: const Color(0xFF02010A),
          child: CustomPaint(
            painter: _NeuralPreviewPainter(accent),
            size: const Size(120, 70),
          ),
        );
      case 'wallpaper':
        return Image.asset(
          'assets/wallpaper.png',
          fit: BoxFit.cover,
          width: 120,
          height: 70,
        );
      case 'wallpaper2':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF020111), Color(0xFF0D0221)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case 'wallpaper3':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF04052E), Color(0xFF140152)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
      default:
        return Container(color: Colors.black);
    }
  }

  // ─── ACCENT COLOR ───────────────────────────────────────
  Widget _buildAccentColorSection() {
    final settings = Get.find<SettingsController>();

    return _settingsCard(
      icon: PhosphorIconsRegular.palette,
      title: 'Accent Color',
      child: Obx(
        () => Row(
          children: List.generate(SettingsController.accentColors.length, (i) {
            final isSelected = settings.accentColorIndex.value == i;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => settings.setAccentColor(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: SettingsController.accentColors[i],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: SettingsController.accentColors[i]
                                    .withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── TRANSPARENCY ───────────────────────────────────────
  Widget _buildTransparencySection() {
    final settings = Get.find<SettingsController>();

    return _settingsCard(
      icon: PhosphorIconsRegular.eyeSlash,
      title: 'Window Transparency',
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'More transparent',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white30,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '${(settings.windowTransparency.value * 100).toInt()}%',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'More opaque',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white30,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: settings.accentColor,
                inactiveTrackColor: AppColors.deepBlue.withValues(alpha: 0.5),
                thumbColor: settings.accentColor,
                overlayColor: settings.accentColor.withValues(alpha: 0.2),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                value: settings.windowTransparency.value,
                min: 0.85,
                max: 1.0,
                onChanged: settings.setTransparency,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CLOCK ──────────────────────────────────────────────
  Widget _buildClockSection() {
    final settings = Get.find<SettingsController>();

    return _settingsCard(
      icon: PhosphorIconsRegular.clock,
      title: 'Clock Format',
      child: Obx(
        () => Row(
          children: [
            _toggleOption(
              label: '24-hour',
              selected: settings.clock24hr.value,
              onTap: () => settings.setClock24hr(true),
              accentColor: settings.accentColor,
            ),
            const SizedBox(width: 12),
            _toggleOption(
              label: '12-hour',
              selected: !settings.clock24hr.value,
              onTap: () => settings.setClock24hr(false),
              accentColor: settings.accentColor,
            ),
          ],
        ),
      ),
    );
  }

  // ─── CURSOR ─────────────────────────────────────────────
  Widget _buildCursorSection() {
    final settings = Get.find<SettingsController>();
    final cursors = [
      {'id': 'line', 'label': 'Line', 'preview': '|'},
      {'id': 'block', 'label': 'Block', 'preview': '█'},
      {'id': 'underline', 'label': 'Underline', 'preview': '_'},
    ];

    return _settingsCard(
      icon: PhosphorIconsRegular.terminalWindow,
      title: 'Terminal Cursor',
      child: Obx(
        () => Row(
          children: cursors.map((c) {
            final isSelected = settings.cursorStyle.value == c['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => settings.setCursorStyle(c['id'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? settings.accentColor.withValues(alpha: 0.2)
                          : AppColors.deepBlue.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? settings.accentColor
                            : Colors.white24,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          c['preview']!,
                          style: AppTextStyles.terminal.copyWith(
                            color: isSelected
                                ? settings.accentColor
                                : Colors.white60,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c['label']!,
                          style: AppTextStyles.label.copyWith(
                            color: isSelected ? Colors.white : Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── RESET ──────────────────────────────────────────────
  Widget _buildResetButton() {
    final settings = Get.find<SettingsController>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: settings.resetToDefaults,
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIconsRegular.arrowCounterClockwise,
                color: Colors.redAccent.withValues(alpha: 0.7),
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Reset to Defaults',
                style: AppTextStyles.body.copyWith(
                  color: Colors.redAccent.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPERS ────────────────────────────────────────────
  Widget _settingsCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white54, size: 14),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _toggleOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color accentColor,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? accentColor.withValues(alpha: 0.2)
                : AppColors.deepBlue.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: selected ? accentColor : Colors.white24),
          ),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected ? Colors.white : Colors.white54,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

// Simple neural network preview painter for wallpaper thumbnail
class _NeuralPreviewPainter extends CustomPainter {
  final Color accent;
  _NeuralPreviewPainter(this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final nodes = [
      Offset(20, 20),
      Offset(60, 15),
      Offset(100, 25),
      Offset(15, 50),
      Offset(50, 45),
      Offset(90, 55),
      Offset(110, 40),
      Offset(30, 65),
      Offset(70, 60),
    ];

    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..color = accent.withValues(alpha: 0.3);

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dist = (nodes[i] - nodes[j]).distance;
        if (dist < 60) {
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    final nodePaint = Paint()..color = accent.withValues(alpha: 0.8);
    for (final node in nodes) {
      canvas.drawCircle(node, 2.5, nodePaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
