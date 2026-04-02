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
  // static const _fiverrGreenDark = Color(0xFF19A463);
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
          // Fiverr Logo
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
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _borderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(PhosphorIconsRegular.magnifyingGlass,
                      color: _textMuted, size: 14),
                  const SizedBox(width: 8),
                  Text('Find services',
                      style: AppTextStyles.label
                          .copyWith(color: _textMuted, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          _navItem('Explore'),
          _navItem('Become a Seller'),
          const SizedBox(width: 8),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _fiverrGreen,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text('Join Fiverr',
                  style: AppTextStyles.label.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(label,
          style: AppTextStyles.label
              .copyWith(color: _textPrimary, fontSize: 13)),
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
              const SizedBox(width: 4),
              Text('(12)',
                  style: AppTextStyles.label
                      .copyWith(color: _textMuted, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: _borderColor, height: 1),
          const SizedBox(height: 16),

          // Stats
          _statRow(PhosphorIconsRegular.mapPin, 'From', PortfolioData.location),
          const SizedBox(height: 10),
          _statRow(PhosphorIconsRegular.clockCountdown, 'Member since', 'Dec 2022'),
          const SizedBox(height: 10),
          _statRow(PhosphorIconsRegular.clock, 'Avg. response time', '1 hour'),
          const SizedBox(height: 10),
          _statRow(PhosphorIconsRegular.checkCircle, 'Last delivery', '1 day'),
          const SizedBox(height: 16),

          // Contact button
          Container(
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
    return _card(
      title: 'Languages',
      child: Column(
        children: [
          _languageRow('English', 'Conversational'),
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
    return _card(
      title: 'Skills',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: PortfolioData.skills
            .map((s) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Text(s['name'] as String,
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
        _buildGigsSection(),
        const SizedBox(height: 24),
        _buildReviewsSection(),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _card(
      title: 'About Me',
      child: Text(PortfolioData.bio,
          style: AppTextStyles.body
              .copyWith(color: _textPrimary, fontSize: 14, height: 1.6)),
    );
  }

  Widget _buildGigsSection() {
    final gigs = [
      {
        'title': 'I will build your Flutter mobile or web app',
        'price': 'From \$50',
        'rating': '5.0',
        'reviews': '8',
        'tag': 'Flutter',
      },
      {
        'title': 'I will develop a Firebase backend for your app',
        'price': 'From \$40',
        'rating': '5.0',
        'reviews': '4',
        'tag': 'Firebase',
      },
      {
        'title': 'I will build a Python script or automation tool',
        'price': 'From \$20',
        'rating': '5.0',
        'reviews': '3',
        'tag': 'Python',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Gigs',
            style: AppTextStyles.heading
                .copyWith(color: _textPrimary, fontSize: 18)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: gigs.map((g) => _buildGigCard(g)).toList(),
        ),
      ],
    );
  }

  Widget _buildGigCard(Map<String, String> gig) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gig image placeholder
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: _fiverrGreen.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Icon(PhosphorIconsRegular.code,
                  color: _fiverrGreen.withValues(alpha: 0.5), size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gig['title'] ?? '',
                    style: AppTextStyles.label.copyWith(
                        color: _textPrimary, fontSize: 13, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(PhosphorIconsFill.star,
                        color: _starColor, size: 12),
                    const SizedBox(width: 4),
                    Text(gig['rating'] ?? '',
                        style: AppTextStyles.label.copyWith(
                            color: _starColor, fontSize: 12)),
                    const SizedBox(width: 2),
                    Text('(${gig['reviews']})',
                        style: AppTextStyles.label
                            .copyWith(color: _textMuted, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: _borderColor, height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _fiverrGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(gig['tag'] ?? '',
                          style: AppTextStyles.label.copyWith(
                              color: _fiverrGreen, fontSize: 11)),
                    ),
                    Text(gig['price'] ?? '',
                        style: AppTextStyles.label.copyWith(
                            color: _textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = [
      {
        'name': 'Client A',
        'review': 'Excellent work! Delivered a clean Flutter app ahead of schedule.',
        'rating': 5,
      },
      {
        'name': 'Client B',
        'review': 'Very professional, great communication throughout the project.',
        'rating': 5,
      },
      {
        'name': 'Client C',
        'review': 'Built exactly what I needed. Will definitely hire again.',
        'rating': 5,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Reviews',
                style: AppTextStyles.heading
                    .copyWith(color: _textPrimary, fontSize: 18)),
            const SizedBox(width: 12),
            const Icon(PhosphorIconsFill.star, color: _starColor, size: 16),
            const SizedBox(width: 4),
            Text('5.0',
                style: AppTextStyles.body.copyWith(
                    color: _starColor, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Text('(12)',
                style:
                    AppTextStyles.label.copyWith(color: _textMuted)),
          ],
        ),
        const SizedBox(height: 16),
        ...reviews.map((r) => _buildReviewCard(r)),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF374151),
                  shape: BoxShape.circle,
                ),
                child: const Icon(PhosphorIconsRegular.user,
                    color: _textMuted, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review['name'],
                      style: AppTextStyles.label.copyWith(
                          color: _textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  Row(
                    children: List.generate(
                      review['rating'] as int,
                      (i) => const Icon(PhosphorIconsFill.star,
                          color: _starColor, size: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(review['review'],
              style: AppTextStyles.label.copyWith(
                  color: _textPrimary, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
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