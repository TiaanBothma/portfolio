import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:web/web.dart' as web;

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  static const _bgColor = Color(0xFFF8F9FA);
  static const _cardColor = Colors.white;
  static const _textPrimary = Color(0xFF1A1A2E);
  static const _textMuted = Color(0xFF6B7280);
  static const _accentColor = Color(0xFF0D00A4);
  static const _borderColor = Color(0xFFE5E7EB);
  // static const _sectionTitle = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopBar(),
            Center(
              child: Container(
                width: 860,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _buildAbout(),
                              const SizedBox(height: 20),
                              _buildExperience(),
                              const SizedBox(height: 20),
                              _buildProjects(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Right column
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildEducation(),
                              const SizedBox(height: 20),
                              _buildSkills(),
                              const SizedBox(height: 20),
                              _buildCertifications(),
                              const SizedBox(height: 20),
                              _buildContact(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TOP BAR ─────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(PhosphorIconsRegular.filePdf, color: _accentColor, size: 20),
          const SizedBox(width: 10),
          Text(
            'Curriculum Vitae — ${PortfolioData.name}',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const Spacer(),
          // Print button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => web.window.open('/cv.pdf', '_blank'),
              child: _topBarButton(
                icon: PhosphorIconsRegular.printer,
                label: 'Print',
                color: _textMuted,
                borderColor: _borderColor,
                textColor: _textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Download button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => web.window.open('assets/cv.pdf', '_blank'),
              child: _topBarButton(
                icon: PhosphorIconsRegular.downloadSimple,
                label: 'Download PDF',
                color: _accentColor,
                borderColor: _accentColor,
                textColor: _accentColor,
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color borderColor,
    required Color textColor,
    bool filled = false,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: filled ? Colors.white : textColor, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: filled ? Colors.white : textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentColor.withValues(alpha: 0.1),
              border: Border.all(color: _accentColor.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(
                'TB',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PortfolioData.name,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  PortfolioData.role,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: _accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _headerChip(
                      PhosphorIconsRegular.mapPin,
                      PortfolioData.location,
                    ),
                    const SizedBox(width: 16),
                    _headerChip(
                      PhosphorIconsRegular.graduationCap,
                      'NWU — BSc IT',
                    ),
                    const SizedBox(width: 16),
                    _headerChip(
                      PhosphorIconsRegular.circle,
                      PortfolioData.status,
                      color: const Color(0xFF16A34A),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerChip(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color ?? _textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 12,
            color: color ?? _textMuted,
          ),
        ),
      ],
    );
  }

  // ─── ABOUT ───────────────────────────────────────────────
  Widget _buildAbout() {
    return _card(
      title: 'About',
      icon: PhosphorIconsRegular.user,
      child: Text(
        PortfolioData.bio,
        style: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 13,
          color: _textMuted,
          height: 1.7,
        ),
      ),
    );
  }

  // ─── EXPERIENCE ──────────────────────────────────────────
  Widget _buildExperience() {
    return _card(
      title: 'Experience',
      icon: PhosphorIconsRegular.briefcase,
      child: Column(
        children: PortfolioData.experience
            .map((e) => _experienceItem(e))
            .toList(),
      ),
    );
  }

  Widget _experienceItem(Map<String, String> e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5, right: 12),
            decoration: BoxDecoration(
              color: _accentColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['title'] ?? '',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${e['company']} · ${e['type']}',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: _accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${e['period']} · ${e['location']}',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: _textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROJECTS ────────────────────────────────────────────
  Widget _buildProjects() {
    return _card(
      title: 'Projects',
      icon: PhosphorIconsRegular.code,
      child: Column(
        children: PortfolioData.projects.map((p) => _projectItem(p)).toList(),
      ),
    );
  }

  Widget _projectItem(Map<String, String> p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  p['name'] ?? '',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
              ),
              Text(
                p['period'] ?? '',
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 11,
                  color: _textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            p['description'] ?? '',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              color: _textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            children: (p['skills'] ?? '')
                .split(' · ')
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 10,
                        color: _accentColor,
                        fontWeight: FontWeight.w500,
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

  // ─── EDUCATION ───────────────────────────────────────────
  Widget _buildEducation() {
    return _card(
      title: 'Education',
      icon: PhosphorIconsRegular.graduationCap,
      child: Column(
        children: PortfolioData.education
            .map((e) => _educationItem(e))
            .toList(),
      ),
    );
  }

  Widget _educationItem(Map<String, String> e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e['institution'] ?? '',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            e['qualification'] ?? '',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              color: _accentColor,
            ),
          ),
          Text(
            e['period'] ?? '',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 11,
              color: _textMuted,
            ),
          ),
          if (e['note'] != null)
            Text(
              e['note']!,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 11,
                color: _textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  // ─── SKILLS ──────────────────────────────────────────────
  Widget _buildSkills() {
    return _card(
      title: 'Skills',
      icon: PhosphorIconsRegular.lightning,
      child: Column(
        children: PortfolioData.skills.map((s) {
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
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: _textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 11,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: s['level'] as double,
                    backgroundColor: _borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── CERTIFICATIONS ──────────────────────────────────────
  Widget _buildCertifications() {
    return _card(
      title: 'Certifications',
      icon: PhosphorIconsRegular.certificate,
      child: Column(
        children: PortfolioData.certifications
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      PhosphorIconsFill.sealCheck,
                      color: _accentColor,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['title'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _textPrimary,
                            ),
                          ),
                          Text(
                            '${c['issuer']} · ${c['date']}',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 11,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ─── CONTACT ─────────────────────────────────────────────
  Widget _buildContact() {
    return _card(
      title: 'Contact',
      icon: PhosphorIconsRegular.addressBook,
      child: Column(
        children: [
          _contactRow(
            PhosphorIconsRegular.linkedinLogo,
            'LinkedIn',
            PortfolioData.linkedin,
          ),
          const SizedBox(height: 8),
          _contactRow(
            PhosphorIconsRegular.githubLogo,
            'GitHub',
            PortfolioData.github,
          ),
          const SizedBox(height: 8),
          _contactRow(
            PhosphorIconsRegular.handCoins,
            'Fiverr',
            PortfolioData.fiverr,
          ),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String label, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => web.window.open('https://$url', '_blank'),
        child: Row(
          children: [
            Icon(icon, color: _accentColor, size: 14),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  url,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 11,
                    color: _accentColor,
                    decoration: TextDecoration.underline,
                    decorationColor: _accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── CARD ────────────────────────────────────────────────
  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _accentColor, size: 16),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _accentColor,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: _borderColor, height: 16),
          child,
        ],
      ),
    );
  }
}
