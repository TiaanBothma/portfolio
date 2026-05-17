import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/data/case_studies_data.dart';
import 'package:portfolio/os_windows/case_study/case_study_controller.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';
import 'package:web/web.dart' as web;

class CaseStudyWindow extends StatelessWidget {
  const CaseStudyWindow({super.key});

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
              blurRadius: 28,
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
      onPanUpdate: (d) => desktop.dragWindow('casestudy', d.delta),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  PhosphorIconsRegular.briefcase,
                  color: Colors.white54,
                  size: 13,
                ),
                const SizedBox(width: 8),
                Text('case studies', style: AppTextStyles.label),
              ],
            ),
            MinimizeButton(onTap: () => desktop.toggleWindow('casestudy')),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(SettingsController settings) {
    return Row(
      children: [
        _buildProjectSelector(settings),
        _verticalDivider(settings),
        Expanded(child: _buildCaseStudy(settings)),
      ],
    );
  }

  Widget _buildProjectSelector(SettingsController settings) {
    final controller = Get.find<CaseStudyController>();

    return Container(
      width: 245,
      color: settings.surface.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT PROJECT',
            style: AppTextStyles.label.copyWith(
              color: Colors.white30,
              fontSize: 10,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(
              () {
                final selectedIndex = controller.selectedIndex.value;

                return ListView.separated(
                  itemCount: CaseStudiesData.all.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final study = CaseStudiesData.all[index];
                    return _ProjectTile(
                      study: study,
                      selected: selectedIndex == index,
                      accentColor: settings.accentColor,
                      surfaceColor: settings.surface,
                      onTap: () => controller.select(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseStudy(SettingsController settings) {
    final controller = Get.find<CaseStudyController>();

    return Obx(() {
      final study = controller.selected;
      return Column(
        children: [
          _buildStudyHeader(study, settings),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section(
                    icon: PhosphorIconsRegular.warning,
                    title: 'Problem',
                    color: Colors.redAccent,
                    body: study.problem,
                    settings: settings,
                  ),
                  _section(
                    icon: PhosphorIconsRegular.funnel,
                    title: 'Constraints',
                    color: const Color(0xFFFFBD2E),
                    body: study.constraints,
                    settings: settings,
                  ),
                  _section(
                    icon: PhosphorIconsRegular.lightbulb,
                    title: 'Solution',
                    color: const Color(0xFF00FF88),
                    body: study.solution,
                    settings: settings,
                  ),
                  _decisionsSection(study, settings),
                  _section(
                    icon: PhosphorIconsRegular.trophy,
                    title: 'Outcome',
                    color: const Color(0xFFB983FF),
                    body: study.outcome,
                    settings: settings,
                  ),
                  _section(
                    icon: PhosphorIconsRegular.bookOpen,
                    title: 'What I Learned',
                    color: Colors.white70,
                    body: study.learned,
                    settings: settings,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStudyHeader(CaseStudy study, SettingsController settings) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 18, 18, 18),
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.26),
        border: Border(
          bottom: BorderSide(color: settings.accentColor.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        study.projectName,
                        style: AppTextStyles.heading.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      study.period,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: study.techStack
                      .map((tech) => _chip(tech, settings))
                      .toList(),
                ),
              ],
            ),
          ),
          if (study.liveUrl != null)
            _LinkButton(
              accentColor: settings.accentColor,
              onTap: () => web.window.open(study.liveUrl!, '_blank'),
            ),
        ],
      ),
    );
  }

  Widget _chip(String text, SettingsController settings) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: settings.accentColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: settings.accentColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: AppTextStyles.label.copyWith(
          color: Colors.white70,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required String title,
    required Color color,
    required String body,
    required SettingsController settings,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(icon, title, color),
          const SizedBox(height: 10),
          Text(
            body,
            style: AppTextStyles.body.copyWith(
              color: Colors.white70,
              height: 1.65,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _decisionsSection(CaseStudy study, SettingsController settings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: settings.surface.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: settings.accentColor.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            PhosphorIconsRegular.code,
            'Tech Decisions',
            settings.accentColor,
          ),
          const SizedBox(height: 12),
          ...study.techDecisions.map(
            (decision) => _decisionItem(decision, settings),
          ),
        ],
      ),
    );
  }

  Widget _decisionItem(TechDecision decision, SettingsController settings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: settings.background.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(color: settings.accentColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            decision.decision,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            decision.reasoning,
            style: AppTextStyles.body.copyWith(
              color: Colors.white60,
              height: 1.5,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: AppTextStyles.label.copyWith(
            color: color,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider(SettingsController settings) {
    return Container(
      width: 1,
      color: settings.accentColor.withValues(alpha: 0.18),
    );
  }
}

class _ProjectTile extends StatefulWidget {
  final CaseStudy study;
  final bool selected;
  final Color accentColor;
  final Color surfaceColor;
  final VoidCallback onTap;

  const _ProjectTile({
    required this.study,
    required this.selected,
    required this.accentColor,
    required this.surfaceColor,
    required this.onTap,
  });

  @override
  State<_ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<_ProjectTile> {
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active
                ? widget.accentColor.withValues(alpha: 0.16)
                : widget.surfaceColor.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.selected
                  ? widget.accentColor
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.study.projectName,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.study.period,
                style: AppTextStyles.label.copyWith(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                widget.study.techStack.take(3).join(' / '),
                style: AppTextStyles.label.copyWith(
                  color: widget.selected ? Colors.white70 : Colors.white54,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkButton extends StatefulWidget {
  final Color accentColor;
  final VoidCallback onTap;

  const _LinkButton({required this.accentColor, required this.onTap});

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
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
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _hovered
                ? widget.accentColor.withValues(alpha: 0.22)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.35),
            ),
          ),
          child: Icon(
            PhosphorIconsRegular.link,
            color: _hovered ? Colors.white : Colors.white60,
            size: 16,
          ),
        ),
      ),
    );
  }
}
