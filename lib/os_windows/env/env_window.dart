import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/data/env_data.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';

class EnvWindow extends StatelessWidget {
  const EnvWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(
      () => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: settings.background.withValues(
            alpha: settings.windowTransparency.value,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: settings.accentColor.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: settings.accentColor.withValues(alpha: 0.12),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTitleBar(settings),
            Expanded(child: _buildBody(settings)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar(SettingsController settings) {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (d) => desktop.dragWindow('env', d.delta),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: settings.surface.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          border: Border(
            bottom: BorderSide(
              color: settings.accentColor.withValues(alpha: 0.3),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(
              PhosphorIconsRegular.terminalWindow,
              color: Colors.white54,
              size: 13,
            ),
            const SizedBox(width: 8),
            Text('environment', style: AppTextStyles.label),
            const Spacer(),
            _CopyEnvButton(accentColor: settings.accentColor),
            const SizedBox(width: 8),
            MinimizeButton(onTap: () => desktop.toggleWindow('env')),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(SettingsController settings) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: settings.surface.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: settings.accentColor.withValues(alpha: 0.22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'printenv /portfolio',
              style: AppTextStyles.terminal.copyWith(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: EnvData.all
                      .map((env) => _envLine(env, settings))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _envLine(EnvVariable env, SettingsController settings) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.terminal.copyWith(fontSize: 12, height: 1.35),
          children: [
            TextSpan(
              text: env.key,
              style: TextStyle(
                color: settings.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: '=',
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: env.value,
              style: const TextStyle(color: Color(0xFF00FF88)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CopyEnvButton extends StatefulWidget {
  final Color accentColor;

  const _CopyEnvButton({required this.accentColor});

  @override
  State<_CopyEnvButton> createState() => _CopyEnvButtonState();
}

class _CopyEnvButtonState extends State<_CopyEnvButton> {
  bool _hovered = false;
  bool _copied = false;

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: EnvData.asText()));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _copied ? null : _handleCopy,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _copied
                ? const Color(0xFF00FF88).withValues(alpha: 0.15)
                : _hovered
                ? widget.accentColor.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _copied
                  ? const Color(0xFF00FF88).withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _copied
                    ? PhosphorIconsRegular.checkCircle
                    : PhosphorIconsRegular.copy,
                color: _copied
                    ? const Color(0xFF00FF88)
                    : _hovered
                    ? Colors.white
                    : Colors.white54,
                size: 13,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 150),
                child: _copied
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Copied',
                          style: AppTextStyles.label.copyWith(
                            color: const Color(0xFF00FF88),
                            fontSize: 11,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
