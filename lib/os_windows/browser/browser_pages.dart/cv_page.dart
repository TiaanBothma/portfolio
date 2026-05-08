import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:web/web.dart' as web;

class CvPage extends StatefulWidget {
  const CvPage({super.key});

  @override
  State<CvPage> createState() => _CvPageState();
}

class _CvPageState extends State<CvPage> with TickerProviderStateMixin {
  Offset _mousePosition = Offset.zero;
  Offset _smoothMouse = Offset.zero;
  late AnimationController _shimmerController;
  late AnimationController _floatController;
  Size _size = Size.zero;

  // Smooth interpolation factor
  static const double _lerpFactor = 0.08;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _onMouseMove(PointerEvent event) {
    setState(() {
      _mousePosition = event.localPosition;
      // Smooth lerp toward target
      _smoothMouse = Offset(
        _smoothMouse.dx + (_mousePosition.dx - _smoothMouse.dx) * _lerpFactor,
        _smoothMouse.dy + (_mousePosition.dy - _smoothMouse.dy) * _lerpFactor,
      );
    });
  }

  double get _tiltX {
    if (_size.height == 0) return 0;
    final centered = (_smoothMouse.dy / _size.height) - 0.5;
    return centered * -0.15; // radians
  }

  double get _tiltY {
    if (_size.width == 0) return 0;
    final centered = (_smoothMouse.dx / _size.width) - 0.5;
    return centered * 0.15;
  }

  double get _mousePercentX =>
      _size.width == 0 ? 0.5 : (_smoothMouse.dx / _size.width).clamp(0, 1);
  double get _mousePercentY =>
      _size.height == 0 ? 0.5 : (_smoothMouse.dy / _size.height).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(() {
      final accent = settings.accentColor;

      return MouseRegion(
        onHover: (e) => _onMouseMove(e),
        child: LayoutBuilder(
          builder: (context, constraints) {
            _size = Size(constraints.maxWidth, constraints.maxHeight);
            return AnimatedBuilder(
              animation: Listenable.merge([
                _shimmerController,
                _floatController,
              ]),
              builder: (context, _) {
                return Stack(
                  children: [
                    // Layer 1 — animated background
                    _buildBackground(accent),
                    // Layer 2 — particle field
                    CustomPaint(
                      painter: _ParticlePainter(
                        progress: _shimmerController.value,
                        accent: accent,
                        mouseX: _mousePercentX,
                        mouseY: _mousePercentY,
                      ),
                      size: _size,
                    ),
                    // Layer 3 — cursor light bloom
                    _buildCursorBloom(accent),
                    // Layer 4 — main CV card with 3D tilt
                    Center(child: _build3DCard(accent)),
                  ],
                );
              },
            );
          },
        ),
      );
    });
  }

  // ─── BACKGROUND ─────────────────────────────────────────
  Widget _buildBackground(Color accent) {
    final gradX = _mousePercentX;
    final gradY = _mousePercentY;

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(gradX * 2 - 1, gradY * 2 - 1),
          radius: 1.5,
          colors: [
            accent.withValues(alpha: 0.15),
            const Color(0xFF02010A),
            const Color(0xFF02010A),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  // ─── CURSOR BLOOM ───────────────────────────────────────
  Widget _buildCursorBloom(Color accent) {
    return Positioned(
      left: _smoothMouse.dx - 150,
      top: _smoothMouse.dy - 150,
      child: IgnorePointer(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [accent.withValues(alpha: 0.08), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }

  // ─── 3D CARD ────────────────────────────────────────────
  Widget _build3DCard(Color accent) {
    final float = sin(_floatController.value * pi) * 6;

    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(_tiltX)
        ..rotateY(_tiltY)
        ..setTranslationRaw(0.0, float, 0.0),
      child: Container(
        width: 920,
        constraints: BoxConstraints(maxHeight: _size.height * 0.92),
        decoration: BoxDecoration(
          color: const Color(0xFF02010A).withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.4), width: 1),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.2),
              blurRadius: 40,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Holographic shimmer overlay
              _buildShimmerOverlay(accent),
              // CV content
              _buildCvContent(accent),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SHIMMER OVERLAY ────────────────────────────────────
  Widget _buildShimmerOverlay(Color accent) {
    final shimmerX = _mousePercentX;
    final shimmerY = _mousePercentY;

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(shimmerX * 2 - 1, shimmerY * 2 - 1),
              end: Alignment((shimmerX * 2 - 1) + 1, (shimmerY * 2 - 1) + 1),
              colors: [
                Colors.transparent,
                accent.withValues(alpha: 0.04),
                Colors.white.withValues(alpha: 0.02),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── CV CONTENT ─────────────────────────────────────────
  Widget _buildCvContent(Color accent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          _buildCvHeader(accent),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildCvSection(
                        accent: accent,
                        icon: PhosphorIconsRegular.user,
                        title: 'About',
                        child: Text(
                          PortfolioData.bio,
                          style: AppTextStyles.label.copyWith(
                            color: Colors.white60,
                            fontSize: 12,
                            height: 1.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCvSection(
                        accent: accent,
                        icon: PhosphorIconsRegular.briefcase,
                        title: 'Experience',
                        child: Column(
                          children: PortfolioData.experience
                              .map((e) => _experienceItem(e, accent))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCvSection(
                        accent: accent,
                        icon: PhosphorIconsRegular.code,
                        title: 'Projects',
                        child: Column(
                          children: PortfolioData.projects
                              .map((p) => _projectItem(p, accent))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildCvSection(
                        accent: accent,
                        icon: PhosphorIconsRegular.graduationCap,
                        title: 'Education',
                        child: Column(
                          children: PortfolioData.education
                              .map((e) => _educationItem(e, accent))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCvSection(
                        accent: accent,
                        icon: PhosphorIconsRegular.lightning,
                        title: 'Skills',
                        child: Column(
                          children: PortfolioData.skills
                              .map((s) => _skillBar(s, accent))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCvSection(
                        accent: accent,
                        icon: PhosphorIconsRegular.certificate,
                        title: 'Certifications',
                        child: Column(
                          children: PortfolioData.certifications
                              .take(5)
                              .map((c) => _certItem(c, accent))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildContactSection(accent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── CV HEADER ──────────────────────────────────────────
  Widget _buildCvHeader(Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: accent.withValues(alpha: 0.2), width: 1),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: 0.12), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.15),
              border: Border.all(
                color: accent.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                'TB',
                style: AppTextStyles.heading.copyWith(
                  color: accent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PortfolioData.name,
                  style: AppTextStyles.display.copyWith(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  PortfolioData.role,
                  style: AppTextStyles.body.copyWith(
                    color: accent,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _headerTag(
                      PhosphorIconsRegular.mapPin,
                      PortfolioData.location,
                    ),
                    const SizedBox(width: 16),
                    _headerTag(
                      PhosphorIconsRegular.graduationCap,
                      'NWU — BSc IT',
                    ),
                    const SizedBox(width: 16),
                    _headerTag(
                      PhosphorIconsRegular.circle,
                      PortfolioData.status,
                      color: const Color(0xFF00FF88),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action buttons
          Column(
            children: [
              _actionButton(
                icon: PhosphorIconsRegular.downloadSimple,
                label: 'Download CV',
                accent: accent,
                onTap: () => web.window.open('/cv.pdf', '_blank'),
              ),
              const SizedBox(height: 8),
              _actionButton(
                icon: PhosphorIconsRegular.printer,
                label: 'Print',
                accent: accent,
                filled: false,
                onTap: () => web.window.open('/cv.pdf', '_blank'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerTag(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color ?? Colors.white38),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.label.copyWith(
            color: color ?? Colors.white38,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color accent,
    required VoidCallback onTap,
    bool filled = true,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: filled ? accent.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: accent.withValues(alpha: filled ? 0.6 : 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: accent, size: 13),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: filled ? Colors.white : Colors.white60,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SECTION ────────────────────────────────────────────
  Widget _buildCvSection({
    required Color accent,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 13),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.label.copyWith(
                  color: accent,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            height: 16,
            thickness: 1,
            color: accent.withValues(alpha: 0.15),
          ),
          child,
        ],
      ),
    );
  }

  // ─── EXPERIENCE ITEM ────────────────────────────────────
  Widget _experienceItem(Map<String, String> e, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 4, right: 8),
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['title'] ?? '',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${e['company']} · ${e['type']}',
                  style: AppTextStyles.label.copyWith(
                    color: accent,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '${e['period']} · ${e['location']}',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROJECT ITEM ───────────────────────────────────────
  Widget _projectItem(Map<String, String> p, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                p['name'] ?? '',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                p['period'] ?? '',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white30,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            p['description'] ?? '',
            style: AppTextStyles.label.copyWith(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: (p['skills'] ?? '')
                .split(' · ')
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      s,
                      style: AppTextStyles.label.copyWith(
                        color: accent,
                        fontSize: 9,
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

  // ─── EDUCATION ITEM ─────────────────────────────────────
  Widget _educationItem(Map<String, String> e, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e['institution'] ?? '',
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            e['qualification'] ?? '',
            style: AppTextStyles.label.copyWith(color: accent, fontSize: 11),
          ),
          Text(
            e['period'] ?? '',
            style: AppTextStyles.label.copyWith(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
          if (e['note'] != null)
            Text(
              e['note']!,
              style: AppTextStyles.label.copyWith(
                color: Colors.white30,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  // ─── SKILL BAR ──────────────────────────────────────────
  Widget _skillBar(Map<String, dynamic> s, Color accent) {
    final percent = ((s['level'] as double) * 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s['name'] as String,
                style: AppTextStyles.label.copyWith(
                  color: Colors.white60,
                  fontSize: 11,
                ),
              ),
              Text(
                '$percent%',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white30,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: s['level'] as double,
              backgroundColor: accent.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                accent.withValues(alpha: 0.8),
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  // ─── CERT ITEM ──────────────────────────────────────────
  Widget _certItem(Map<String, String> c, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(PhosphorIconsFill.sealCheck, color: accent, size: 12),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c['title'] ?? '',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${c['issuer']} · ${c['date']}',
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
    );
  }

  // ─── CONTACT ────────────────────────────────────────────
  Widget _buildContactSection(Color accent) {
    return _buildCvSection(
      accent: accent,
      icon: PhosphorIconsRegular.addressBook,
      title: 'Contact',
      child: Column(
        children: [
          _contactRow(
            PhosphorIconsRegular.linkedinLogo,
            'LinkedIn',
            PortfolioData.linkedin,
            accent,
          ),
          const SizedBox(height: 6),
          _contactRow(
            PhosphorIconsRegular.githubLogo,
            'GitHub',
            PortfolioData.github,
            accent,
          ),
          const SizedBox(height: 6),
          _contactRow(
            PhosphorIconsRegular.handCoins,
            'Fiverr',
            PortfolioData.fiverr,
            accent,
          ),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String label, String url, Color accent) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => web.window.open('https://$url', '_blank'),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 13),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                url,
                style: AppTextStyles.label.copyWith(
                  color: accent.withValues(alpha: 0.8),
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                  decorationColor: accent.withValues(alpha: 0.4),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PARTICLE PAINTER ───────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color accent;
  final double mouseX;
  final double mouseY;

  static final List<_Particle> _particles = [];
  static bool _initialized = false;

  _ParticlePainter({
    required this.progress,
    required this.accent,
    required this.mouseX,
    required this.mouseY,
  }) {
    if (!_initialized) {
      final random = Random(42);
      for (int i = 0; i < 80; i++) {
        _particles.add(
          _Particle(
            x: random.nextDouble(),
            y: random.nextDouble(),
            size: random.nextDouble() * 1.5 + 0.5,
            speed: random.nextDouble() * 0.0002 + 0.0001,
            phase: random.nextDouble(),
          ),
        );
      }
      _initialized = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final p in _particles) {
      // Drift upward slowly
      final y = (p.y - progress * p.speed * 100) % 1.0;
      final x =
          p.x + sin(progress * 2 * pi + p.phase) * 0.01 + (mouseX - 0.5) * 0.02;

      final opacity = (sin(progress * 2 * pi + p.phase) + 1) / 2 * 0.4 + 0.1;
      paint.color = accent.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x * size.width, y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      old.progress != progress || old.accent != accent;
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
}
