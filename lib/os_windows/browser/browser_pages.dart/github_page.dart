import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/themes/text_style.dart';

class GitHubPage extends StatelessWidget {
  const GitHubPage({super.key});

  static const _bgColor = Color(0xFF0D1117);
  static const _cardColor = Color(0xFF161B22);
  static const _borderColor = Color(0xFF30363D);
  static const _textMuted = Color(0xFF8B949E);
  static const _textPrimary = Color(0xFFE6EDF3);
  // static const _accentGreen = Color(0xFF238636);
  static const _linkBlue = Color(0xFF58A6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopNav(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 260, child: _buildSidebar()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 48,
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsFill.githubLogo,
            color: _textPrimary,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _borderColor),
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
                    'Search or jump to...',
                    style: AppTextStyles.label.copyWith(
                      color: _textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          _navItem('Pull requests'),
          _navItem('Issues'),
          _navItem('Marketplace'),
          _navItem('Explore'),
        ],
      ),
    );
  }

  Widget _navItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(color: _textPrimary, fontSize: 13),
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _borderColor, width: 1),
            color: const Color(0xFF21262D),
          ),
          child: const Icon(
            PhosphorIconsRegular.user,
            color: _textMuted,
            size: 80,
          ),
        ),
        const SizedBox(height: 16),

        // Name
        Text(
          PortfolioData.name,
          style: AppTextStyles.heading.copyWith(
            color: _textPrimary,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),

        // Username
        Text(
          'tiaanbothma',
          style: AppTextStyles.body.copyWith(color: _textMuted, fontSize: 16),
        ),
        const SizedBox(height: 16),

        // Bio
        Text(
          'Flutter Full Stack Developer · BSc IT @ NWU · Building + Learning + Developing',
          style: AppTextStyles.body.copyWith(
            color: _textPrimary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Follow button
        Container(
          width: double.infinity,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF21262D),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _borderColor),
          ),
          child: Center(
            child: Text(
              'Follow',
              style: AppTextStyles.label.copyWith(
                color: _textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Stats
        Row(
          children: [
            const Icon(PhosphorIconsRegular.users, color: _textMuted, size: 14),
            const SizedBox(width: 6),
            Text(
              '12 ',
              style: AppTextStyles.label.copyWith(
                color: _textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'followers · ',
              style: AppTextStyles.label.copyWith(color: _textMuted),
            ),
            Text(
              '8 ',
              style: AppTextStyles.label.copyWith(
                color: _textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'following',
              style: AppTextStyles.label.copyWith(color: _textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Location
        _sidebarItem(PhosphorIconsRegular.mapPin, PortfolioData.location),
        const SizedBox(height: 8),

        // University
        _sidebarItem(PhosphorIconsRegular.graduationCap, 'NWU — BSc IT'),
        const SizedBox(height: 8),

        // LinkedIn
        _sidebarItem(
          PhosphorIconsRegular.linkedinLogo,
          PortfolioData.linkedin,
          color: _linkBlue,
        ),
        const SizedBox(height: 8),

        // Fiverr
        _sidebarItem(
          PhosphorIconsRegular.handCoins,
          PortfolioData.fiverr,
          color: _linkBlue,
        ),
      ],
    );
  }

  Widget _sidebarItem(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: _textMuted, size: 14),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: color ?? _textPrimary,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(),
        const SizedBox(height: 16),
        _buildPinnedRepos(),
        const SizedBox(height: 24),
        _buildContributionGraph(),
      ],
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        _tab('Overview', active: true),
        _tab('Repositories', count: PortfolioData.projects.length.toString()),
        _tab('Projects'),
        _tab('Stars'),
      ],
    );
  }

  Widget _tab(String label, {bool active = false, String? count}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: active ? const Color(0xFFF78166) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: active ? _textPrimary : _textMuted,
              fontSize: 13,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _borderColor),
              ),
              child: Text(
                count,
                style: AppTextStyles.label.copyWith(
                  color: _textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPinnedRepos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pinned',
          style: AppTextStyles.body.copyWith(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: PortfolioData.projects
              .map((p) => _buildRepoCard(p))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRepoCard(Map<String, String> project) {
    final langColor = _langColor(project['skills'] ?? '');
    final langName = _langName(project['skills'] ?? '');

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                PhosphorIconsRegular.bookBookmark,
                color: _textMuted,
                size: 14,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  project['name'] ?? '',
                  style: AppTextStyles.label.copyWith(
                    color: _linkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _borderColor),
                ),
                child: Text(
                  'Public',
                  style: AppTextStyles.label.copyWith(
                    color: _textMuted,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project['description'] ?? '',
            style: AppTextStyles.label.copyWith(
              color: _textMuted,
              fontSize: 12,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: langColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                langName,
                style: AppTextStyles.label.copyWith(
                  color: _textMuted,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              const Icon(
                PhosphorIconsRegular.star,
                color: _textMuted,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '0',
                style: AppTextStyles.label.copyWith(
                  color: _textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContributionGraph() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '83 contributions in the last year',
            style: AppTextStyles.body.copyWith(
              color: _textPrimary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          _buildGraph(),
        ],
      ),
    );
  }

  Widget _buildGraph() {
    final random = [
      [0, 1, 0, 2, 0, 0, 1],
      [0, 0, 3, 1, 0, 2, 0],
      [1, 0, 0, 4, 0, 0, 1],
      [0, 2, 1, 0, 3, 0, 0],
      [1, 0, 0, 2, 0, 4, 0],
      [0, 1, 0, 0, 2, 0, 1],
      [0, 0, 2, 1, 0, 0, 3],
      [1, 3, 0, 0, 1, 2, 0],
      [0, 0, 1, 4, 0, 0, 2],
      [2, 1, 0, 0, 3, 1, 0],
      [0, 0, 4, 0, 0, 2, 1],
      [1, 0, 0, 2, 1, 0, 0],
      [0, 3, 1, 0, 0, 2, 1],
      [2, 0, 0, 1, 0, 0, 3],
      [0, 1, 2, 0, 1, 0, 0],
      [0, 0, 0, 3, 0, 2, 1],
      [1, 2, 0, 0, 4, 0, 0],
      [0, 0, 1, 2, 0, 1, 0],
      [3, 0, 0, 0, 1, 0, 2],
      [0, 1, 0, 3, 0, 0, 1],
      [0, 0, 2, 0, 1, 3, 0],
      [1, 0, 0, 1, 0, 0, 4],
      [0, 2, 1, 0, 2, 0, 0],
      [1, 0, 0, 0, 0, 1, 2],
      [0, 3, 0, 1, 0, 0, 1],
      [2, 0, 1, 0, 3, 0, 0],
    ];

    return Row(
      children: random.map((week) {
        return Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Column(
            children: week.map((level) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  color: _contributionColor(level),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Color _contributionColor(int level) {
    switch (level) {
      case 0:
        return const Color(0xFF161B22);
      case 1:
        return const Color(0xFF0E4429);
      case 2:
        return const Color(0xFF006D32);
      case 3:
        return const Color(0xFF26A641);
      case 4:
        return const Color(0xFF39D353);
      default:
        return const Color(0xFF161B22);
    }
  }

  Color _langColor(String skills) {
    if (skills.contains('Flutter')) return const Color(0xFF54C5F8);
    if (skills.contains('Python')) return const Color(0xFF3572A5);
    if (skills.contains('Docker')) return const Color(0xFF384D54);
    return const Color(0xFF8B949E);
  }

  String _langName(String skills) {
    if (skills.contains('Flutter')) return 'Flutter';
    if (skills.contains('Python')) return 'Python';
    if (skills.contains('Docker')) return 'Docker';
    return 'Dart';
  }
}
