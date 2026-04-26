import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/themes/text_style.dart';

class FiverrPage extends StatelessWidget {
  const FiverrPage({super.key});

  static const _bgColor = Color(0xFF1A1C1E);
  static const _cardColor = Color(0xFF242526);
  static const _borderColor = Color(0xFF3A3B3C);
  static const _textPrimary = Color(0xFFE4E6EB);
  static const _textMuted = Color(0xFF8A8D91);
  static const _fiverrGreen = Color(0xFF1DBF73);
  static const _starColor = Color(0xFFFFBD2E);

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
                width: 900,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 280, child: _buildSidebar()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildMainContent()),
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
      height: 56,
      color: const Color(0xFF242526),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Fiverr logo
          Row(
            children: [
              Text('fiverr',
                  style: AppTextStyles.heading.copyWith(
                      color: _textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Text('.',
                  style: AppTextStyles.heading.copyWith(
                      color: _fiverrGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 24),

          // Tagline instead of search bar
          Text(
            'Custom Flutter apps, built right.',
            style: AppTextStyles.label.copyWith(
              color: _textMuted,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),

          const Spacer(),

          // View Profile button
          GestureDetector(
            // onTap: () =>
                // launchUrl(Uri.parse('https://${PortfolioData.fiverr}')),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _fiverrGreen),
              ),
              child: Center(
                child: Text('View Profile',
                    style: AppTextStyles.label.copyWith(
                        color: _fiverrGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Order Now button
          GestureDetector(
            // onTap: () =>
                // launchUrl(Uri.parse('https://${PortfolioData.fiverr}')),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _fiverrGreen,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text('Order Now',
                    style: AppTextStyles.label.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        _buildSellerCard(),
        const SizedBox(height: 16),
        _buildLanguagesCard(),
        const SizedBox(height: 16),
        _buildSkillsCard(),
      ],
    );
  }

  Widget _buildSellerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _fiverrGreen.withValues(alpha: 0.2),
              border: Border.all(color: _fiverrGreen, width: 2),
            ),
            child: const Icon(PhosphorIconsRegular.user,
                color: _textMuted, size: 36),
          ),
          const SizedBox(height: 12),

          Text(PortfolioData.name,
              style: AppTextStyles.body.copyWith(
                  color: _textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 2),
          Text('@tiaanbothma',
              style: AppTextStyles.label
                  .copyWith(color: _textMuted, fontSize: 13)),
          const SizedBox(height: 12),

          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                  5,
                  (i) => const Icon(PhosphorIconsFill.star,
                      color: _starColor, size: 14)),
              const SizedBox(width: 6),
              Text('5.0',
                  style: AppTextStyles.label.copyWith(
                      color: _starColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: _borderColor, height: 1),
          const SizedBox(height: 16),

          // Stats
          _statRow(PhosphorIconsRegular.mapPin, 'From',
              PortfolioData.location),
          const SizedBox(height: 10),
          _statRow(PhosphorIconsRegular.clockCountdown, 'Member since',
              'Dec 2022'),
          const SizedBox(height: 10),
          _statRow(
              PhosphorIconsRegular.clock, 'Avg. response time', '1 hour'),
          const SizedBox(height: 16),

          // Contact Me button
          GestureDetector(
            // onTap: () =>
                // launchUrl(Uri.parse('https://${PortfolioData.fiverr}')),
            child: Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: _fiverrGreen,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text('Contact Me',
                    style: AppTextStyles.label.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: _textMuted, size: 14),
            const SizedBox(width: 6),
            Text(label,
                style: AppTextStyles.label
                    .copyWith(color: _textMuted, fontSize: 12)),
          ],
        ),
        Text(value,
            style: AppTextStyles.label
                .copyWith(color: _textPrimary, fontSize: 12)),
      ],
    );
  }

  Widget _buildLanguagesCard() {
    return _sideCard(
      title: 'Languages',
      child: Column(
        children: [
          _languageRow('English', 'Native / Bilingual'),
          const SizedBox(height: 8),
          _languageRow('Afrikaans', 'Native / Bilingual'),
        ],
      ),
    );
  }

  Widget _languageRow(String lang, String level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lang,
            style: AppTextStyles.label
                .copyWith(color: _textPrimary, fontSize: 13)),
        Text(level,
            style: AppTextStyles.label
                .copyWith(color: _textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildSkillsCard() {
    final technicalSkills = [
      'Flutter', 'Dart', 'Firebase', 'Cloud Firestore',
      'Docker', 'Python', 'Linux', 'HTML',
      'SQL', 'Git / GitHub', 'Web Development',
      'Full-Stack Development', 'Server Management',
      'Networking', 'Cybersecurity',
    ];

    return _sideCard(
      title: 'Skills',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: technicalSkills
            .map((s) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Text(s,
                      style: AppTextStyles.label
                          .copyWith(color: _textPrimary, fontSize: 12)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAboutSection(),
        const SizedBox(height: 24),
        _buildGigSection(),
        const SizedBox(height: 24),
        _buildWhatIOfferSection(),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _mainCard(
      title: 'About Me',
      child: Text(PortfolioData.bio,
          style: AppTextStyles.body
              .copyWith(color: _textPrimary, fontSize: 14, height: 1.6)),
    );
  }

  Widget _buildGigSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Gig',
            style: AppTextStyles.heading
                .copyWith(color: _textPrimary, fontSize: 18)),
        const SizedBox(height: 16),
        GestureDetector(
          // onTap: () =>
              // launchUrl(Uri.parse('https://${PortfolioData.fiverr}')),
          child: Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              children: [
                // Gig image
                Container(
                  width: 160,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _fiverrGreen.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Icon(PhosphorIconsRegular.deviceMobile,
                        color: _fiverrGreen.withValues(alpha: 0.6),
                        size: 48),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I will build, develop and publish your Flutter application',
                          style: AppTextStyles.body.copyWith(
                              color: _textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Full Flutter app development for mobile and web using Flutter and Cloud Firestore.',
                          style: AppTextStyles.label
                              .copyWith(color: _textMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Stars
                            ...List.generate(
                                5,
                                (i) => const Icon(PhosphorIconsFill.star,
                                    color: _starColor, size: 12)),
                            const SizedBox(width: 6),
                            Text('5.0',
                                style: AppTextStyles.label.copyWith(
                                    color: _starColor, fontSize: 12)),
                            const Spacer(),
                            // Price
                            Text('From ',
                                style: AppTextStyles.label
                                    .copyWith(color: _textMuted, fontSize: 13)),
                            Text('\$50',
                                style: AppTextStyles.body.copyWith(
                                    color: _textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Order button
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: _fiverrGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text('Order Now',
                                style: AppTextStyles.label.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatIOfferSection() {
    final offerings = [
      {
        'icon': PhosphorIconsRegular.deviceMobile,
        'title': 'Mobile & Web Apps',
        'description':
            'Full Flutter applications for Android, iOS and Web with clean UI and solid architecture.',
      },
      {
        'icon': PhosphorIconsRegular.database,
        'title': 'Firebase Backend',
        'description':
            'Cloud Firestore database design, Firebase Auth, Storage and real-time data handling.',
      },
      {
        'icon': PhosphorIconsRegular.paintBrush,
        'title': 'UI / UX Design',
        'description':
            'Clean, modern interfaces designed for usability with attention to detail.',
      },
      {
        'icon': PhosphorIconsRegular.rocket,
        'title': 'Publishing & Deployment',
        'description':
            'App Store, Google Play and Firebase Web Hosting deployment handled end to end.',
      },
      {
        'icon': PhosphorIconsRegular.wrench,
        'title': 'Maintenance & Support',
        'description':
            'Bug fixes, feature additions and ongoing support for existing Flutter apps.',
      },
      {
        'icon': PhosphorIconsRegular.gitBranch,
        'title': 'Clean Architecture',
        'description':
            'Scalable project structure, state management with GetX, and maintainable codebases.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What I Offer',
            style: AppTextStyles.heading
                .copyWith(color: _textPrimary, fontSize: 18)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: offerings.map((o) => _buildOfferingCard(o)).toList(),
        ),
      ],
    );
  }

  Widget _buildOfferingCard(Map<String, dynamic> offering) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _fiverrGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(offering['icon'] as IconData,
                color: _fiverrGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offering['title'] as String,
                    style: AppTextStyles.label.copyWith(
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(offering['description'] as String,
                    style: AppTextStyles.label.copyWith(
                        color: _textMuted,
                        fontSize: 12,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.body.copyWith(
                  color: _textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _mainCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.heading
                  .copyWith(color: _textPrimary, fontSize: 18)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}