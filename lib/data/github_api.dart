import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubRepo {
  final String name;
  final String description;
  final String language;
  final int stars;
  final int forks;
  final String url;
  final String updatedAt;

  const GitHubRepo({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
    required this.forks,
    required this.url,
    required this.updatedAt,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'] ?? '',
      description: json['description'] ?? 'No description',
      language: json['language'] ?? 'Unknown',
      stars: json['stargazers_count'] ?? 0,
      forks: json['forks_count'] ?? 0,
      url: json['html_url'] ?? '',
      updatedAt: _formatDate(json['updated_at'] ?? ''),
    );
  }

  static String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final date = DateTime.parse(iso);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return '';
    }
  }
}

class GitHubApi {
  static const String _username = 'TiaanBothma';
  static const String _baseUrl = 'https://api.github.com';

  static Future<List<GitHubRepo>> fetchRepos() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$_username/repos?sort=updated&per_page=20'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => GitHubRepo.fromJson(json))
            .where((repo) => !repo.name.startsWith('.'))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$_username'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {};
    } catch (_) {
      return {};
    }
  }
}
