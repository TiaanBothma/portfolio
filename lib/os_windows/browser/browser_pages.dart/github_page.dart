import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/data/github_api.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:web/web.dart' as web;

class GitHubPage extends StatefulWidget {
  const GitHubPage({super.key});

  @override
  State<GitHubPage> createState() => _GitHubPageState();
}

class _GitHubPageState extends State<GitHubPage> {
  static const _bgColor = Color(0xFF0D1117);
  static const _cardColor = Color(0xFF161B22);
  static const _borderColor = Color(0xFF30363D);
  static const _textMuted = Color(0xFF8B949E);
  static const _textPrimary = Color(0xFFE6EDF3);
  static const _linkBlue = Color(0xFF58A6FF);

  String _activeTab = 'Overview';
  List<GitHubRepo> _repos = [];
  Map<String, dynamic> _profile = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      GitHubApi.fetchRepos(),
      GitHubApi.fetchProfile(),
    ]);
    if (mounted) {
      setState(() {
        _repos = results[0] as List<GitHubRepo>;
        _profile = results[1] as Map<String, dynamic>;
        _loading = false;
      });
    }
  }

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
      color: _cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsFill.githubLogo,
            color: _textPrimary,
            size: 28,
          ),
          const SizedBox(width: 16),
          // Username display instead of search bar
          Text(
            'TiaanBothma',
            style: AppTextStyles.body.copyWith(color: _textMuted, fontSize: 14),
          ),
          const Spacer(),
          // View on GitHub button
          _navButton(
            label: 'View on GitHub',
            icon: PhosphorIconsRegular.arrowSquareOut,

            onTap: () => web.window.open('https://${PortfolioData.github}'),
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF21262D),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: _textMuted, size: 13),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: _textPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final followers = _profile['followers']?.toString() ?? '—';
    final following = _profile['following']?.toString() ?? '—';
    final publicRepos = _profile['public_repos']?.toString() ?? '—';
    final bio = _profile['bio'] as String? ?? PortfolioData.bio;

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
          child: ClipOval(
            child: _profile['avatar_url'] != null
                ? Image.network(
                    _profile['avatar_url'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      PhosphorIconsRegular.user,
                      color: _textMuted,
                      size: 80,
                    ),
                  )
                : const Icon(
                    PhosphorIconsRegular.user,
                    color: _textMuted,
                    size: 80,
                  ),
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
        const SizedBox(height: 2),

        // Username
        Text(
          'TiaanBothma',
          style: AppTextStyles.body.copyWith(color: _textMuted, fontSize: 16),
        ),
        const SizedBox(height: 12),

        // Bio from API
        Text(
          bio,
          style: AppTextStyles.body.copyWith(
            color: _textPrimary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Follow button
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => web.window.open('https://${PortfolioData.github}'),

            child: Container(
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
          ),
        ),
        const SizedBox(height: 16),

        // Real stats from API
        Row(
          children: [
            const Icon(PhosphorIconsRegular.users, color: _textMuted, size: 14),
            const SizedBox(width: 6),
            Text(
              '$followers ',
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
              '$following ',
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
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              PhosphorIconsRegular.bookBookmark,
              color: _textMuted,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              '$publicRepos public repos',
              style: AppTextStyles.label.copyWith(color: _textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _sidebarItem(PhosphorIconsRegular.mapPin, PortfolioData.location),
        _sidebarItem(PhosphorIconsRegular.graduationCap, 'NWU — BSc IT'),
        _sidebarItem(
          PhosphorIconsRegular.linkedinLogo,
          PortfolioData.linkedin,
          color: _linkBlue,
          url: 'https://${PortfolioData.linkedin}',
        ),
        _sidebarItem(
          PhosphorIconsRegular.globe,
          'MO27 Portal',
          color: _linkBlue,
          url: 'https://mo27-1bdd8.web.app/',
        ),
      ],
    );
  }

  Widget _sidebarItem(IconData icon, String text, {Color? color, String? url}) {
    final widget = Row(
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

    if (url != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => web.window.open(url, '_blank'),
            child: widget,
          ),
        ),
      );
    }

    return Padding(padding: const EdgeInsets.only(bottom: 4), child: widget);
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(),
        const SizedBox(height: 16),
        _buildTabContent(),
      ],
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      {'label': 'Overview', 'count': null},
      {'label': 'Repositories', 'count': _repos.length.toString()},
      {
        'label': 'Experience',
        'count': PortfolioData.experience.length.toString(),
      },
    ];

    return Row(
      children: tabs.map((tab) {
        final label = tab['label'] as String;
        final count = tab['count'];
        final active = _activeTab == label;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = label),
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active
                        ? const Color(0xFFF78166)
                        : Colors.transparent,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
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
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTabContent() {
    if (_loading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF58A6FF),
                strokeWidth: 2,
              ),
              const SizedBox(height: 16),
              Text(
                'Fetching from GitHub API...',
                style: AppTextStyles.terminal.copyWith(
                  color: _textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    switch (_activeTab) {
      case 'Overview':
        return _buildOverviewTab();
      case 'Repositories':
        return _buildRepositoriesTab();
      case 'Experience':
        return _buildExperienceTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    final pinnedRepos = _repos.take(6).toList();

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
        pinnedRepos.isEmpty
            ? _buildPortfolioRepoCards()
            : Wrap(
                spacing: 16,
                runSpacing: 16,
                children: pinnedRepos.map((r) => _buildApiRepoCard(r)).toList(),
              ),
        const SizedBox(height: 24),
        _buildRepoStats(),
      ],
    );
  }

  Widget _buildPortfolioRepoCards() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: PortfolioData.projects
          .map((p) => _buildStaticRepoCard(p))
          .toList(),
    );
  }

  Widget _buildApiRepoCard(GitHubRepo repo) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => web.window.open(repo.url, '_blank'),
        child: Container(
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
                      repo.name,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
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
                repo.description,
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
                      color: _langColor(repo.language),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    repo.language,
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
                    repo.stars.toString(),
                    style: AppTextStyles.label.copyWith(
                      color: _textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    PhosphorIconsRegular.gitFork,
                    color: _textMuted,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    repo.forks.toString(),
                    style: AppTextStyles.label.copyWith(
                      color: _textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Updated ${repo.updatedAt}',
                style: AppTextStyles.label.copyWith(
                  color: _textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticRepoCard(Map<String, String> project) {
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
                  color: _langColor(project['skills'] ?? ''),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _langName(project['skills'] ?? ''),
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

  Widget _buildRepositoriesTab() {
    if (_repos.isEmpty) {
      return Center(
        child: Text(
          'No repositories found',
          style: AppTextStyles.body.copyWith(color: _textMuted),
        ),
      );
    }

    return Column(
      children: _repos.map((repo) => _buildRepoListItem(repo)).toList(),
    );
  }

  Widget _buildRepoListItem(GitHubRepo repo) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => web.window.open(repo.url, '_blank'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          repo.name,
                          style: AppTextStyles.body.copyWith(
                            color: _linkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
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
                    const SizedBox(height: 4),
                    Text(
                      repo.description,
                      style: AppTextStyles.label.copyWith(
                        color: _textMuted,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _langColor(repo.language),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          repo.language,
                          style: AppTextStyles.label.copyWith(
                            color: _textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          PhosphorIconsRegular.star,
                          color: _textMuted,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          repo.stars.toString(),
                          style: AppTextStyles.label.copyWith(
                            color: _textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Updated ${repo.updatedAt}',
                          style: AppTextStyles.label.copyWith(
                            color: _textMuted,
                            fontSize: 12,
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
      ),
    );
  }

  Widget _buildExperienceTab() {
    return Column(
      children: PortfolioData.experience.map((e) {
        return Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF21262D),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _borderColor),
                ),
                child: const Icon(
                  PhosphorIconsRegular.briefcase,
                  color: _textMuted,
                  size: 18,
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
                      e['company'] ?? '',
                      style: AppTextStyles.label.copyWith(
                        color: _linkBlue,
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
      }).toList(),
    );
  }

  Color _langColor(String skills) {
    if (skills.contains('Flutter') || skills.contains('Dart')) {
      return const Color(0xFF54C5F8);
    }
    if (skills.contains('Python')) return const Color(0xFF3572A5);
    if (skills.contains('Docker')) return const Color(0xFF384D54);
    if (skills.contains('JavaScript')) return const Color(0xFFF1E05A);
    if (skills.contains('C#')) return const Color(0xFF178600);
    return const Color(0xFF8B949E);
  }

  String _langName(String skills) {
    if (skills.contains('Flutter')) return 'Flutter';
    if (skills.contains('Python')) return 'Python';
    if (skills.contains('Docker')) return 'Docker';
    if (skills.contains('C#')) return 'C#';
    return 'Dart';
  }

  Map<String, int> _getLanguageStats() {
    final Map<String, int> langs = {};
    for (final repo in _repos) {
      if (repo.language.isNotEmpty && repo.language != 'Unknown') {
        langs[repo.language] = (langs[repo.language] ?? 0) + 1;
      }
    }
    // Sort by count descending
    final sorted = Map.fromEntries(
      langs.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  int _getTotalStars() {
    return _repos.fold(0, (sum, repo) => sum + repo.stars);
  }

  Widget _buildRepoStats() {
    if (_loading) return const SizedBox.shrink();

    final langStats = _getLanguageStats();
    final totalStars = _getTotalStars();
    final totalRepos = _repos.length;
    final totalForks = _repos.fold(0, (sum, repo) => sum + repo.forks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Private repos notice
        _buildPrivateReposNotice(),
        const SizedBox(height: 16),

        // Stats row
        Row(
          children: [
            _buildStatCard(
              icon: PhosphorIconsRegular.bookBookmark,
              label: 'Public Repos',
              value: totalRepos.toString(),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              icon: PhosphorIconsRegular.star,
              label: 'Total Stars',
              value: totalStars.toString(),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              icon: PhosphorIconsRegular.gitFork,
              label: 'Total Forks',
              value: totalForks.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Language breakdown
        if (langStats.isNotEmpty) _buildLanguageBreakdown(langStats),
      ],
    );
  }

  Widget _buildPrivateReposNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF21262D),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3D444D), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            PhosphorIconsRegular.lockKey,
            color: Color(0xFF8B949E),
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Most production repositories are private',
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFE6EDF3),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'The majority of my work — including full-stack Flutter apps built for real clients at 18INK Productions and MyEncore CC — lives in private repositories due to client confidentiality. The repos shown here represent personal and open projects.',
                  style: AppTextStyles.label.copyWith(
                    color: const Color(0xFF8B949E),
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF8B949E), size: 16),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading.copyWith(
                color: const Color(0xFFE6EDF3),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: const Color(0xFF8B949E),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageBreakdown(Map<String, int> langStats) {
    final total = langStats.values.fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Languages',
            style: AppTextStyles.body.copyWith(
              color: const Color(0xFFE6EDF3),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Language bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: langStats.entries.map((entry) {
                final percent = entry.value / total;
                return Flexible(
                  flex: (percent * 100).round(),
                  child: Container(height: 8, color: _langColor(entry.key)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Language legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: langStats.entries.map((entry) {
              final percent = ((entry.value / total) * 100).toStringAsFixed(1);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _langColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    entry.key,
                    style: AppTextStyles.label.copyWith(
                      color: const Color(0xFFE6EDF3),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$percent%',
                    style: AppTextStyles.label.copyWith(
                      color: const Color(0xFF8B949E),
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
