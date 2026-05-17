import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/data/timeline_data.dart';
import 'package:portfolio/os_windows/timeline/timeline_controller.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';
import 'package:web/web.dart' as web;

class TimelineWindow extends StatefulWidget {
  const TimelineWindow({super.key});

  @override
  State<TimelineWindow> createState() => _TimelineWindowState();
}

class _TimelineWindowState extends State<TimelineWindow>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    final timeline = Get.find<TimelineController>();

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
            _buildLegend(settings),
            Expanded(child: _buildTimeline(settings, timeline)),
            _buildDetailPanel(settings, timeline),
          ],
        ),
      ),
    );
  }

  // ─── TITLE BAR ──────────────────────────────────────────
  Widget _buildTitleBar(SettingsController settings) {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (d) => desktop.dragWindow('timeline', d.delta),
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
                  PhosphorIconsRegular.timer,
                  color: Colors.white54,
                  size: 13,
                ),
                const SizedBox(width: 8),
                Text('career timeline', style: AppTextStyles.label),
                const SizedBox(width: 12),
                Text(
                  '2022 — Present',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white30,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            MinimizeButton(onTap: () => desktop.toggleWindow('timeline')),
          ],
        ),
      ),
    );
  }

  // ─── LEGEND ─────────────────────────────────────────────
  Widget _buildLegend(SettingsController settings) {
    final types = [
      {'label': 'Job', 'color': const Color(0xFF58A6FF)},
      {'label': 'Project', 'color': const Color(0xFF00FF88)},
      {'label': 'Education', 'color': const Color(0xFFE040FB)},
      {'label': 'Certification', 'color': const Color(0xFFFFBD2E)},
    ];

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.2),
        border: Border(
          bottom: BorderSide(
            color: settings.accentColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'LEGEND',
            style: AppTextStyles.label.copyWith(
              color: Colors.white24,
              fontSize: 9,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 16),
          ...types.map(
            (t) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: t['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    t['label'] as String,
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Click any event to expand',
            style: AppTextStyles.label.copyWith(
              color: Colors.white24,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ─── TIMELINE ───────────────────────────────────────────
  Widget _buildTimeline(
    SettingsController settings,
    TimelineController timeline,
  ) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return CustomPaint(
                painter: _TimelinePainter(
                  events: TimelineData.events,
                  selectedIndex: timeline.selectedIndex.value,
                  accentColor: settings.accentColor,
                  pulseValue: _pulseAnim.value,
                ),
                child: _buildEventDots(settings, timeline),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventDots(
    SettingsController settings,
    TimelineController timeline,
  ) {
    const double eventSpacing = 110.0;
    const double lineY = 120.0;
    const double dotSize = 14.0;
    const double aboveOffset = 60.0;
    const double belowOffset = 60.0;
    final totalWidth = TimelineData.events.length * eventSpacing + 80;

    return SizedBox(
      width: totalWidth,
      height: 240,
      child: Stack(
        children: [
          // Year labels
          ..._buildYearLabels(eventSpacing, lineY),
          // Event dots and labels
          ...TimelineData.events.asMap().entries.map((entry) {
            final i = entry.key;
            final event = entry.value;
            final x = 40.0 + i * eventSpacing;
            final isAbove = event.isAbove;
            final isSelected = timeline.selectedIndex.value == i;
            final dotY = isAbove
                ? lineY - aboveOffset - dotSize / 2
                : lineY + belowOffset - dotSize / 2;

            return Positioned(
              left: x - dotSize / 2,
              top: dotY,
              child: _EventDot(
                event: event,
                index: i,
                isSelected: isSelected,
                dotSize: dotSize,
                isAbove: isAbove,
                lineY: lineY,
                onTap: () => timeline.selectEvent(i),
              ),
            );
          }),
          // YOU ARE HERE dot at end
          _buildNowIndicator(settings, eventSpacing, lineY),
        ],
      ),
    );
  }

  List<Widget> _buildYearLabels(double spacing, double lineY) {
    final years = <Widget>[];
    final events = TimelineData.events;

    Set<int> seenYears = {};
    for (int i = 0; i < events.length; i++) {
      final year = events[i].sortDate.year;
      if (!seenYears.contains(year)) {
        seenYears.add(year);
        final x = 40.0 + i * spacing;
        years.add(
          Positioned(
            left: x - 20,
            top: lineY + 8,
            child: Text(
              year.toString(),
              style: AppTextStyles.label.copyWith(
                color: Colors.white24,
                fontSize: 10,
              ),
            ),
          ),
        );
      }
    }
    return years;
  }

  Widget _buildNowIndicator(
    SettingsController settings,
    double spacing,
    double lineY,
  ) {
    final x = 40.0 + TimelineData.events.length * spacing;

    return Positioned(
      left: x - 6,
      top: lineY - 6,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) => Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: settings.accentColor.withValues(alpha: _pulseAnim.value),
                boxShadow: [
                  BoxShadow(
                    color: settings.accentColor.withValues(
                      alpha: _pulseAnim.value * 0.5,
                    ),
                    blurRadius: 12,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'NOW',
              style: AppTextStyles.label.copyWith(
                color: settings.accentColor.withValues(alpha: _pulseAnim.value),
                fontSize: 8,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── DETAIL PANEL ───────────────────────────────────────
  Widget _buildDetailPanel(
    SettingsController settings,
    TimelineController timeline,
  ) {
    return Obx(() {
      final event = timeline.selectedEvent;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: event != null ? 180 : 0,
        decoration: BoxDecoration(
          color: settings.surface.withValues(alpha: 0.5),
          border: event != null
              ? Border(
                  top: BorderSide(
                    color: event.typeColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: event != null
            ? _buildDetailContent(event, settings, timeline)
            : const SizedBox.shrink(),
      );
    });
  }

  Widget _buildDetailContent(
    TimelineEvent event,
    SettingsController settings,
    TimelineController timeline,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: event.typeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: event.typeColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  event.typeLabel,
                  style: AppTextStyles.label.copyWith(
                    color: event.typeColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                event.title,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '@ ${event.company}',
                style: AppTextStyles.label.copyWith(
                  color: event.typeColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                event.date,
                style: AppTextStyles.label.copyWith(
                  color: Colors.white30,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              if (event.url != null)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => web.window.open(event.url!, '_blank'),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIconsRegular.arrowSquareOut,
                          color: settings.accentColor,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'View Live',
                          style: AppTextStyles.label.copyWith(
                            color: settings.accentColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: timeline.clearSelection,
                  child: Icon(
                    PhosphorIconsRegular.x,
                    color: Colors.white30,
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.detail,
            style: AppTextStyles.label.copyWith(
              color: Colors.white60,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: event.skills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: event.typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: event.typeColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      s,
                      style: AppTextStyles.label.copyWith(
                        color: event.typeColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─── EVENT DOT WIDGET ───────────────────────────────────────
class _EventDot extends StatefulWidget {
  final TimelineEvent event;
  final int index;
  final bool isSelected;
  final double dotSize;
  final bool isAbove;
  final double lineY;
  final VoidCallback onTap;

  const _EventDot({
    required this.event,
    required this.index,
    required this.isSelected,
    required this.dotSize,
    required this.isAbove,
    required this.lineY,
    required this.onTap,
  });

  @override
  State<_EventDot> createState() => _EventDotState();
}

class _EventDotState extends State<_EventDot> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.isAbove
              ? [_buildLabel(), const SizedBox(height: 4), _buildDot()]
              : [_buildDot(), const SizedBox(height: 4), _buildLabel()],
        ),
      ),
    );
  }

  Widget _buildDot() {
    final scale = _hovered || widget.isSelected ? 1.4 : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 150),
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.event.typeColor,
          boxShadow: _hovered || widget.isSelected
              ? [
                  BoxShadow(
                    color: widget.event.typeColor.withValues(alpha: 0.6),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Text(
            widget.event.title,
            style: AppTextStyles.label.copyWith(
              color: _hovered || widget.isSelected
                  ? Colors.white
                  : Colors.white60,
              fontSize: 9,
              fontWeight: _hovered || widget.isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.event.date,
            style: AppTextStyles.label.copyWith(
              color: widget.event.typeColor.withValues(alpha: 0.7),
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── TIMELINE PAINTER ───────────────────────────────────────
class _TimelinePainter extends CustomPainter {
  final List<TimelineEvent> events;
  final int? selectedIndex;
  final Color accentColor;
  final double pulseValue;

  static const double eventSpacing = 110.0;
  static const double lineY = 120.0;

  _TimelinePainter({
    required this.events,
    required this.selectedIndex,
    required this.accentColor,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw main timeline line in segments — colored by event proximity
    for (int i = 0; i < events.length - 1; i++) {
      final x1 = 40.0 + i * eventSpacing;
      final x2 = 40.0 + (i + 1) * eventSpacing;
      final midX = (x1 + x2) / 2;

      // First half — color of left event
      linePaint.color = events[i].typeColor.withValues(alpha: 0.4);
      canvas.drawLine(Offset(x1, lineY), Offset(midX, lineY), linePaint);

      // Second half — color of right event
      linePaint.color = events[i + 1].typeColor.withValues(alpha: 0.4);
      canvas.drawLine(Offset(midX, lineY), Offset(x2, lineY), linePaint);
    }

    // Extend line to NOW indicator
    final lastX = 40.0 + (events.length - 1) * eventSpacing;
    final nowX = 40.0 + events.length * eventSpacing;
    linePaint.color = accentColor.withValues(alpha: pulseValue * 0.6);
    canvas.drawLine(Offset(lastX, lineY), Offset(nowX, lineY), linePaint);

    // Draw connector lines from dots to timeline
    final connectorPaint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < events.length; i++) {
      final x = 40.0 + i * eventSpacing;
      final event = events[i];
      final isAbove = event.isAbove;
      final isSelected = selectedIndex == i;

      connectorPaint.color = event.typeColor.withValues(
        alpha: isSelected ? 0.8 : 0.3,
      );

      final dotY = isAbove ? lineY - 60 : lineY + 60;

      canvas.drawLine(Offset(x, lineY), Offset(x, dotY), connectorPaint);
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.selectedIndex != selectedIndex ||
      old.pulseValue != pulseValue ||
      old.accentColor != accentColor;
}
