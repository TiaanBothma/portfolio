import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:web/web.dart' as web;

class LinkedInPage extends StatelessWidget {
  const LinkedInPage({super.key});

  static const _bgColor = Color(0xFF1B1F23);
  static const _cardColor = Color(0xFF242A30);
  static const _borderColor = Color(0xFF2F3640);
  static const _textPrimary = Color(0xFFE8E8E8);
  static const _textMuted = Color(0xFF9AA5B1);
  static const _linkedInBlue = Color(0xFF0A66C2);
  static const _linkedInLightBlue = Color(0xFF70B5F9);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopNav(),
            Center(
              child: SizedBox(
                width: 860,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildMainColumn()),
                      const SizedBox(width: 24),
                      SizedBox(width: 240, child: _buildRightColumn()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 52,
      color: const Color(0xFF1D2226),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsFill.linkedinLogo,
            color: _linkedInBlue,
            size: 34,
          ),
          const SizedBox(width: 8),
          Container(
            width: 220,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(
                  PhosphorIconsRegular.magnifyingGlass,
                  color: _textMuted,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search',
                  style: AppTextStyles.label.copyWith(
                    color: _textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _navIcon(PhosphorIconsRegular.house, 'Home'),
          _navIcon(PhosphorIconsRegular.users, 'Network'),
          _navIcon(PhosphorIconsRegular.briefcase, 'Jobs'),
          _navIcon(PhosphorIconsRegular.chatCircle, 'Messaging'),
          _navIcon(PhosphorIconsRegular.bell, 'Notifications'),
          const SizedBox(width: 16),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: _linkedInLightBlue),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Premium',
                style: AppTextStyles.label.copyWith(
                  color: _linkedInLightBlue,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _textMuted, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: _textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainColumn() {
    return Column(
      children: [
        _buildProfileCard(),
        const SizedBox(height: 8),
        _buildAboutCard(),
        const SizedBox(height: 8),
        _buildExperienceCard(),
        const SizedBox(height: 8),
        _buildEducationCard(),
        const SizedBox(height: 8),
        _buildSkillsCard(),
        const SizedBox(height: 8),
        _buildCertificationsCard(),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: _linkedInBlue.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF374151),
                      border: Border.all(color: _cardColor, width: 3),
                    ),
                    child: const Icon(
                      PhosphorIconsRegular.user,
                      color: _textMuted,
                      size: 36,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PortfolioData.name,
                        style: AppTextStyles.heading.copyWith(
                          color: _textPrimary,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        PortfolioData.role,
                        style: AppTextStyles.body.copyWith(
                          color: _textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${PortfolioData.university} · ${PortfolioData.location}',
                        style: AppTextStyles.label.copyWith(
                          color: _textMuted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,

                            child: GestureDetector(
                              onTap: () {
                                web.window.open(
                                  'https://${PortfolioData.linkedin}',
                                  '_blank',
                                );
                              },
                              child: _profileButton('Connect', filled: true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                web.window.open(
                                  'https://${PortfolioData.linkedin}',
                                  '_blank',
                                );
                              },
                              child: _profileButton('Message'),
                            ),
                          ),
                        ],
                      ),
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

  Widget _profileButton(String label, {bool filled = false}) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: filled ? _linkedInBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: filled ? _linkedInBlue : _linkedInLightBlue),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: filled ? Colors.white : _linkedInLightBlue,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAboutCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('About'),
          const SizedBox(height: 12),
          Text(
            PortfolioData.bio,
            style: AppTextStyles.body.copyWith(
              color: _textPrimary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Experience'),
          const SizedBox(height: 16),
          ...PortfolioData.experience.map((e) => _experienceItem(e)),
        ],
      ),
    );
  }

  Widget _experienceItem(Map<String, String> e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              PhosphorIconsRegular.briefcase,
              color: _textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['title'] ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: _textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${e['company']} · ${e['type']}',
                  style: AppTextStyles.label.copyWith(
                    color: _textPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${e['period']} · ${e['location']}',
                  style: AppTextStyles.label.copyWith(
                    color: _textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Education'),
          const SizedBox(height: 16),
          ...PortfolioData.education.map((e) => _educationItem(e)),
        ],
      ),
    );
  }

  Widget _educationItem(Map<String, String> e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              PhosphorIconsRegular.graduationCap,
              color: _textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['institution'] ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: _textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  e['qualification'] ?? '',
                  style: AppTextStyles.label.copyWith(
                    color: _textPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  e['period'] ?? '',
                  style: AppTextStyles.label.copyWith(
                    color: _textMuted,
                    fontSize: 12,
                  ),
                ),
                if (e['note'] != null)
                  Text(
                    e['note']!,
                    style: AppTextStyles.label.copyWith(
                      color: _textMuted,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Skills'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PortfolioData.skills
                .map((s) => _skillChip(s['name'] as String))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _skillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _linkedInBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _linkedInBlue.withValues(alpha: 0.4)),
      ),
      child: Text(
        skill,
        style: AppTextStyles.label.copyWith(
          color: _linkedInLightBlue,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCertificationsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Licenses & Certifications'),
          const SizedBox(height: 16),
          ...PortfolioData.certifications.map((c) => _certItem(c)),
        ],
      ),
    );
  }

  Widget _certItem(Map<String, String> c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              PhosphorIconsRegular.certificate,
              color: _textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c['title'] ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: _textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  c['issuer'] ?? '',
                  style: AppTextStyles.label.copyWith(
                    color: _textPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Issued ${c['date']}',
                  style: AppTextStyles.label.copyWith(
                    color: _textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildProfileStrengthCard(),
        const SizedBox(height: 8),
        _buildOpenToWorkCard(),
      ],
    );
  }

  Widget _buildProfileStrengthCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Profile Strength'),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.85,
            backgroundColor: _borderColor,
            color: _linkedInBlue,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 8),
          Text(
            'All-Star',
            style: AppTextStyles.label.copyWith(
              color: _linkedInLightBlue,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenToWorkCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _linkedInBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _linkedInBlue.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF57C855),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Open to work',
                style: AppTextStyles.body.copyWith(
                  color: _textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter Developer · Full Stack · Remote',
            style: AppTextStyles.label.copyWith(
              color: _textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: child,
    );
  }

  Widget _cardTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading.copyWith(color: _textPrimary, fontSize: 18),
    );
  }
}
