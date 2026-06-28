import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  final ScrollController _scrollController = ScrollController();

  static const double _leftPad = 220;
  static const double _eventSpacing = 172;
  static const double _railY = 54;
  static const double _laneTop = 92;
  static const double _laneHeight = 124;
  static const double _cardWidth = 150;
  static const double _cardHeight = 96;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.45, end: 1.0).animate(
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
            _buildHeader(settings),
            Expanded(child: _buildTimeline(settings, timeline)),
            _buildDetailPanel(settings, timeline),
          ],
        ),
      ),
    );
  }

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
                  'high school -> freelance -> production -> university',
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

  Widget _buildHeader(SettingsController settings) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.18),
        border: Border(
          bottom: BorderSide(
            color: settings.accentColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          _stat('START', 'Grade 10', settings),
          const SizedBox(width: 12),
          _stat('FIRST CLIENT', 'Age 15', settings),
          const SizedBox(width: 12),
          _stat('NOW', 'NWU + 18INK', settings),
          const Spacer(),
          _legendItem('Job', TimelineEventType.job),
          _legendItem('Project', TimelineEventType.project),
          _legendItem('Education', TimelineEventType.education),
          _legendItem('Cert', TimelineEventType.certification),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, SettingsController settings) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: settings.background.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: settings.accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: Colors.white30,
              fontSize: 9,
              letterSpacing: 1.1,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, TimelineEventType type) {
    final color = _typeColor(type);
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
    SettingsController settings,
    TimelineController timeline,
  ) {
    final entries = _entries();
    final width = _leftPad + entries.length * _eventSpacing + 150;
    const height = _laneTop + _laneHeight * 4 + 24;

    return Listener(
      onPointerSignal: (event) {
        if (event is! PointerScrollEvent) return;
        if (!_scrollController.hasClients) return;

        final scrollDelta = event.scrollDelta.dy.abs() >
                event.scrollDelta.dx.abs()
            ? event.scrollDelta.dy
            : event.scrollDelta.dx;
        final nextOffset = (_scrollController.offset + scrollDelta).clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        );

        _scrollController.jumpTo(nextOffset);
      },
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 8),
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(width, height),
                      painter: _TimelineRailPainter(
                        entries: entries,
                        selectedIndex: timeline.selectedIndex.value,
                        accentColor: settings.accentColor,
                        pulse: _pulseAnim.value,
                        leftPad: _leftPad,
                        spacing: _eventSpacing,
                        railY: _railY,
                        laneTop: _laneTop,
                        laneHeight: _laneHeight,
                        cardWidth: _cardWidth,
                        cardHeight: _cardHeight,
                      ),
                    ),
                    ..._buildLaneLabels(settings),
                    ...entries.map(
                      (entry) => _buildEventCard(entry, settings, timeline),
                    ),
                    _buildNowMarker(entries.length, settings),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLaneLabels(SettingsController settings) {
    final labels = [
      ('JOBS', TimelineEventType.job),
      ('PROJECTS', TimelineEventType.project),
      ('SCHOOL / UNI', TimelineEventType.education),
      ('CERTS', TimelineEventType.certification),
    ];

    return labels.asMap().entries.map((entry) {
      final lane = entry.key;
      final label = entry.value.$1;
      final color = _typeColor(entry.value.$2);
      return Positioned(
        left: 18,
        top: _laneTop + lane * _laneHeight + 36,
        child: Container(
          width: 92,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.22)),
          ),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildEventCard(
    _TimelineEntry entry,
    SettingsController settings,
    TimelineController timeline,
  ) {
    final event = entry.event;
    final x = _leftPad + entry.position * _eventSpacing;
    final laneY = _laneTop + _laneFor(event.type) * _laneHeight + 14;

    return Positioned(
      left: x - _cardWidth / 2,
      top: laneY,
      child: Obx(() {
        final selected = timeline.selectedIndex.value == entry.originalIndex;
        return _TimelineCard(
          event: event,
          selected: selected,
          width: _cardWidth,
          height: _cardHeight,
          accentColor: settings.accentColor,
          surfaceColor: settings.surface,
          onTap: () => timeline.selectEvent(entry.originalIndex),
        );
      }),
    );
  }

  Widget _buildNowMarker(int count, SettingsController settings) {
    final x = _leftPad + count * _eventSpacing;
    return Positioned(
      left: x - 24,
      top: _railY - 19,
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: settings.accentColor.withValues(alpha: _pulseAnim.value),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: settings.accentColor.withValues(
                    alpha: _pulseAnim.value * 0.5,
                  ),
                  blurRadius: 14,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'NOW',
            style: AppTextStyles.label.copyWith(
              color: settings.accentColor,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(
    SettingsController settings,
    TimelineController timeline,
  ) {
    return Obx(() {
      final event = timeline.selectedEvent;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: event != null ? 188 : 0,
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
        child: event == null
            ? const SizedBox.shrink()
            : _buildDetailContent(event, settings, timeline),
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
              _typeBadge(event),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  event.title,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                event.date,
                style: AppTextStyles.label.copyWith(
                  color: event.typeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              if (event.url != null)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => web.window.open(event.url!, '_blank'),
                    child: Icon(
                      PhosphorIconsRegular.arrowSquareOut,
                      color: settings.accentColor,
                      size: 15,
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
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${event.company} - ${event.summary}',
            style: AppTextStyles.label.copyWith(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            event.detail,
            style: AppTextStyles.label.copyWith(
              color: Colors.white54,
              fontSize: 12,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 5,
            children: event.skills
                .map((skill) => _skillChip(skill, event))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _typeBadge(TimelineEvent event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: event.typeColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: event.typeColor.withValues(alpha: 0.45)),
      ),
      child: Text(
        event.typeLabel,
        style: AppTextStyles.label.copyWith(
          color: event.typeColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _skillChip(String skill, TimelineEvent event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: event.typeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: event.typeColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        skill,
        style: AppTextStyles.label.copyWith(
          color: event.typeColor,
          fontSize: 10,
        ),
      ),
    );
  }

  List<_TimelineEntry> _entries() {
    final entries = TimelineData.events.asMap().entries.toList()
      ..sort((a, b) => a.value.sortDate.compareTo(b.value.sortDate));

    return entries
        .asMap()
        .entries
        .map(
          (entry) => _TimelineEntry(
            originalIndex: entry.value.key,
            position: entry.key,
            event: entry.value.value,
          ),
        )
        .toList();
  }

  int _laneFor(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.job:
        return 0;
      case TimelineEventType.project:
        return 1;
      case TimelineEventType.education:
        return 2;
      case TimelineEventType.certification:
        return 3;
    }
  }

  Color _typeColor(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.job:
        return const Color(0xFF58A6FF);
      case TimelineEventType.project:
        return const Color(0xFF00FF88);
      case TimelineEventType.education:
        return const Color(0xFFE040FB);
      case TimelineEventType.certification:
        return const Color(0xFFFFBD2E);
    }
  }
}

class _TimelineEntry {
  final int originalIndex;
  final int position;
  final TimelineEvent event;

  const _TimelineEntry({
    required this.originalIndex,
    required this.position,
    required this.event,
  });
}

class _TimelineCard extends StatefulWidget {
  final TimelineEvent event;
  final bool selected;
  final double width;
  final double height;
  final Color accentColor;
  final Color surfaceColor;
  final VoidCallback onTap;

  const _TimelineCard({
    required this.event,
    required this.selected,
    required this.width,
    required this.height,
    required this.accentColor,
    required this.surfaceColor,
    required this.onTap,
  });

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: active
                ? widget.event.typeColor.withValues(alpha: 0.16)
                : widget.surfaceColor.withValues(alpha: 0.26),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: active
                  ? widget.event.typeColor
                  : Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: widget.event.typeColor.withValues(alpha: 0.22),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _dateChip(widget.event)),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: widget.event.typeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Expanded(
                child: Text(
                  widget.event.title,
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.event.company,
                style: AppTextStyles.label.copyWith(
                  color: Colors.white38,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateChip(TimelineEvent event) {
    return Text(
      event.date.toUpperCase(),
      style: AppTextStyles.label.copyWith(
        color: event.typeColor,
        fontSize: 9,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TimelineRailPainter extends CustomPainter {
  final List<_TimelineEntry> entries;
  final int? selectedIndex;
  final Color accentColor;
  final double pulse;
  final double leftPad;
  final double spacing;
  final double railY;
  final double laneTop;
  final double laneHeight;
  final double cardWidth;
  final double cardHeight;

  _TimelineRailPainter({
    required this.entries,
    required this.selectedIndex,
    required this.accentColor,
    required this.pulse,
    required this.leftPad,
    required this.spacing,
    required this.railY,
    required this.laneTop,
    required this.laneHeight,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawLaneBands(canvas, size);
    _drawYearBands(canvas);
    _drawRail(canvas, size);
    _drawConnectors(canvas);
  }

  void _drawLaneBands(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int lane = 0; lane < 4; lane++) {
      paint.color = Colors.white.withValues(alpha: lane.isEven ? 0.018 : 0.0);
      canvas.drawRect(
        Rect.fromLTWH(0, laneTop + lane * laneHeight, size.width, laneHeight),
        paint,
      );

      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.055)
        ..strokeWidth = 1;
      final y = laneTop + lane * laneHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  void _drawYearBands(Canvas canvas) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final seen = <int>{};

    for (final entry in entries) {
      final year = entry.event.sortDate.year;
      if (!seen.add(year)) continue;

      final x = leftPad + entry.position * spacing;
      final markerPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(x, 17), Offset(x, railY + 18), markerPaint);

      textPainter.text = TextSpan(
        text: year.toString(),
        style: AppTextStyles.label.copyWith(
          color: Colors.white30,
          fontSize: 10,
          letterSpacing: 1,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, 4));
    }
  }

  void _drawRail(Canvas canvas, Size size) {
    final startX = leftPad;
    final endX = leftPad + entries.length * spacing;
    final railPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          entries.first.event.typeColor.withValues(alpha: 0.45),
          accentColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(startX, railY - 2, endX - startX, 4))
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(startX, railY), Offset(endX, railY), railPaint);

    final nowPaint = Paint()
      ..color = accentColor.withValues(alpha: pulse)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(endX, railY), 7, nowPaint);
  }

  void _drawConnectors(Canvas canvas) {
    for (final entry in entries) {
      final event = entry.event;
      final x = leftPad + entry.position * spacing;
      final lane = _laneFor(event.type);
      final cardTop = laneTop + lane * laneHeight + 14;
      final cardCenterY = cardTop + cardHeight / 2;
      final selected = selectedIndex == entry.originalIndex;
      final color = event.typeColor;

      final connectorPaint = Paint()
        ..color = color.withValues(alpha: selected ? 0.85 : 0.32)
        ..strokeWidth = selected ? 1.8 : 1.1;

      canvas.drawLine(Offset(x, railY), Offset(x, cardCenterY), connectorPaint);

      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, railY), selected ? 6.5 : 4.5, dotPaint);

      if (selected) {
        final haloPaint = Paint()
          ..color = color.withValues(alpha: 0.18)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, railY), 13, haloPaint);
      }
    }
  }

  int _laneFor(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.job:
        return 0;
      case TimelineEventType.project:
        return 1;
      case TimelineEventType.education:
        return 2;
      case TimelineEventType.certification:
        return 3;
    }
  }

  @override
  bool shouldRepaint(_TimelineRailPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.pulse != pulse ||
      oldDelegate.accentColor != accentColor ||
      oldDelegate.entries.length != entries.length;
}
