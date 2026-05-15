import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/os_windows/monitor/monitor_controller.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';

class MonitorWindow extends StatelessWidget {
  const MonitorWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    final monitor = Get.find<MonitorController>();

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
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: settings.accentColor.withValues(alpha: 0.15),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTitleBar(settings),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSystemInfo(settings),
                    const SizedBox(height: 16),
                    _buildResourceBars(settings, monitor),
                    const SizedBox(height: 16),
                    _buildGraph(settings, monitor),
                    const SizedBox(height: 16),
                    _buildProcessList(settings, monitor),
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
  Widget _buildTitleBar(SettingsController settings) {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (d) => desktop.dragWindow('monitor', d.delta),
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
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  PhosphorIconsRegular.chartLine,
                  color: Colors.white54,
                  size: 13,
                ),
                const SizedBox(width: 8),
                Text('system monitor', style: AppTextStyles.label),
              ],
            ),
            MinimizeButton(onTap: () => desktop.toggleWindow('monitor')),
          ],
        ),
      ),
    );
  }

  // ─── SYSTEM INFO ────────────────────────────────────────
  Widget _buildSystemInfo(SettingsController settings) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: settings.accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _infoItem('OS', 'Tiaan Bothma OS ${PortfolioData.version}'),
          ),
          Expanded(child: _infoItem('Developer', PortfolioData.name)),
          Expanded(child: _infoItem('Stack', 'Flutter · Firebase · Dart')),
          Expanded(child: _infoItem('Status', PortfolioData.status)),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: Colors.white30,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.label.copyWith(
            color: Colors.white,
            fontSize: 11,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ─── RESOURCE BARS ──────────────────────────────────────
  Widget _buildResourceBars(
    SettingsController settings,
    MonitorController monitor,
  ) {
    return Obx(
      () => Column(
        children: [
          _resourceBar(
            'Flutter.sys — Frontend',
            monitor.cpuValue.value,
            settings,
            isHighlighted: true,
          ),
          const SizedBox(height: 8),
          _resourceBar(
            'Firebase.sys — Backend',
            monitor.memValue.value,
            settings,
          ),
          const SizedBox(height: 8),
          _resourceBar('Dart.sys — Runtime', monitor.netValue.value, settings),
          const SizedBox(height: 8),
          _resourceBar(
            'Docker.sys — Infrastructure',
            monitor.dskValue.value,
            settings,
          ),
        ],
      ),
    );
  }

  Widget _resourceBar(
    String label,
    double value,
    SettingsController settings, {
    bool isHighlighted = false,
  }) {
    final percent = (value * 100).toInt();
    final color = isHighlighted ? settings.accentColor : _barColor(value);

    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Text(
            label,
            style: AppTextStyles.terminal.copyWith(
              color: isHighlighted ? settings.accentColor : Colors.white60,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: settings.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: 14,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '$percent%',
            style: AppTextStyles.terminal.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color _barColor(double value) {
    if (value > 0.85) return Colors.redAccent;
    if (value > 0.65) return const Color(0xFFFFBD2E);
    return const Color(0xFF00FF88);
  }

  // ─── GRAPH ──────────────────────────────────────────────
  Widget _buildGraph(SettingsController settings, MonitorController monitor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: settings.accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flutter.sys — CPU History',
            style: AppTextStyles.label.copyWith(
              color: Colors.white54,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => SizedBox(
              height: 60,
              child: CustomPaint(
                painter: _GraphPainter(
                  values: monitor.cpuHistory.toList(),
                  color: settings.accentColor,
                ),
                size: const Size(double.infinity, 60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROCESS LIST ───────────────────────────────────────
  Widget _buildProcessList(
    SettingsController settings,
    MonitorController monitor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: settings.accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: settings.surface.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'PROCESS',
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white30,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'CPU',
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white30,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'MEM',
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white30,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Rows
          Obx(
            () => Column(
              children: monitor.processes.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                final cpu = ((p['cpu'] as double) * 100).toInt();
                final isEven = i % 2 == 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isEven
                        ? Colors.white.withValues(alpha: 0.02)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: settings.accentColor.withValues(
                                  alpha: 0.8,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              p['exe'] as String,
                              style: AppTextStyles.terminal.copyWith(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '$cpu%',
                          style: AppTextStyles.terminal.copyWith(
                            color: _barColor(p['cpu'] as double),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '${p['mem']} MB',
                          style: AppTextStyles.terminal.copyWith(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── GRAPH PAINTER ──────────────────────────────────────────
class _GraphPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _GraphPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo((values.length - 1) * stepX, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_GraphPainter old) =>
      old.values != values || old.color != color;
}
