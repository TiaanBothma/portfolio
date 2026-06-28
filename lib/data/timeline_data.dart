import 'package:flutter/material.dart';

enum TimelineEventType { job, project, education, certification }

class TimelineEvent {
  final String date;
  final DateTime sortDate;
  final TimelineEventType type;
  final String title;
  final String company;
  final String summary;
  final String detail;
  final List<String> skills;
  final String? url;

  const TimelineEvent({
    required this.date,
    required this.sortDate,
    required this.type,
    required this.title,
    required this.company,
    required this.summary,
    required this.detail,
    this.skills = const [],
    this.url,
  });

  Color get typeColor {
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

  String get typeLabel {
    switch (type) {
      case TimelineEventType.job:
        return 'JOB';
      case TimelineEventType.project:
        return 'PROJECT';
      case TimelineEventType.education:
        return 'EDUCATION';
      case TimelineEventType.certification:
        return 'CERT';
    }
  }

  // Above the line: jobs and education
  // Below the line: projects and certifications
  bool get isAbove =>
      type == TimelineEventType.job || type == TimelineEventType.education;
}

class TimelineData {
  TimelineData._();

  static final List<TimelineEvent> events = [
    TimelineEvent(
      date: 'Jan 2022',
      sortDate: DateTime(2022, 1),
      type: TimelineEventType.education,
      title: 'High School',
      company: 'Hoerskool Noordheuwel',
      summary: 'Started Grade 10 while building toward IT',
      detail:
          'Started the high-school stretch where the software journey became serious. This context matters because the first freelance clients, hospitality work, and professional development roles all happened while still completing school.',
      skills: const ['Information Technology', 'Discipline', 'Time Management'],
    ),
    TimelineEvent(
      date: 'Dec 2022',
      sortDate: DateTime(2022, 12),
      type: TimelineEventType.job,
      title: 'Started Freelancing',
      company: 'Fiverr',
      summary: 'First paying client at age 15',
      detail:
          'Started delivering custom Flutter applications and small Python scripts to international clients on Fiverr while in Grade 10. Built games, interactive tools, and mobile apps. First exposure to real client communication, deadlines, and requirements gathering.',
      skills: const ['Flutter', 'Python', 'Unity', 'Client Communication'],
    ),
    TimelineEvent(
      date: 'Nov 2023',
      sortDate: DateTime(2023, 11),
      type: TimelineEventType.job,
      title: 'Waiter',
      company: 'Bergvallei Estates',
      summary: 'Hospitality job alongside school',
      detail:
          'Worked part-time as a waiter during Grade 11 and 12 while simultaneously managing software projects and studying. Developed strong multitasking, communication under pressure, and teamwork skills in a fast-paced environment.',
      skills: ['Teamwork', 'Communication', 'Multitasking'],
    ),
    TimelineEvent(
      date: 'Nov 2023',
      sortDate: DateTime(2023, 11, 15),
      type: TimelineEventType.certification,
      title: 'CCNA Fundamentals',
      company: 'Simplilearn',
      summary: 'Networking fundamentals certification',
      detail:
          'Completed the Cisco Certified Network Associate fundamentals course covering TCP/IP, subnetting, routing protocols, and network administration concepts.',
      skills: ['Networking', 'TCP/IP', 'Routing'],
    ),
    TimelineEvent(
      date: 'Dec 2023',
      sortDate: DateTime(2023, 12),
      type: TimelineEventType.certification,
      title: 'Fortinet Cybersecurity',
      company: 'Fortinet',
      summary: 'Cybersecurity fundamentals',
      detail:
          'Earned Fortinet Certified Fundamentals in Cybersecurity covering threat landscapes, security protocols, and fundamental defence concepts.',
      skills: ['Cybersecurity', 'Security Protocols', 'Threat Analysis'],
    ),
    TimelineEvent(
      date: 'Feb 2024',
      sortDate: DateTime(2024, 2),
      type: TimelineEventType.job,
      title: 'Full Stack Developer',
      company: 'MyEncore CC',
      summary: 'School app development in a team',
      detail:
          'Developed a comprehensive school application using Flutter. Designed user interfaces, managed databases, collaborated with a team to integrate modules, and conducted testing and debugging. First professional team environment.',
      skills: ['Flutter', 'Firebase', 'Team Collaboration', 'UI/UX'],
    ),
    TimelineEvent(
      date: 'Feb 2024',
      sortDate: DateTime(2024, 2, 15),
      type: TimelineEventType.job,
      title: 'Software Engineer',
      company: '18INK Productions',
      summary: 'Professional remote Flutter engineer',
      detail:
          'Joined 18INK Productions as a part-time remote Software Engineer during Grade 11. Built and maintained full-stack production applications for real clients. Currently still in this role alongside university studies. Developed skills in Cloud Firestore, Firebase Storage, state management, and agile methodologies.',
      skills: ['Flutter', 'Cloud Firestore', 'Firebase', 'Dart', 'GetX'],
    ),
    TimelineEvent(
      date: 'Feb 2024',
      sortDate: DateTime(2024, 2, 20),
      type: TimelineEventType.certification,
      title: 'Flutter Course',
      company: 'Simplilearn',
      summary: 'Formal Flutter certification',
      detail:
          'Completed Simplilearn Flutter course certification covering Flutter fundamentals, state management, and mobile app development best practices.',
      skills: ['Flutter', 'Dart', 'Mobile Development'],
    ),
    TimelineEvent(
      date: 'Jun 2024',
      sortDate: DateTime(2024, 6),
      type: TimelineEventType.project,
      title: 'MO27 Portal',
      company: '18INK Productions',
      summary: 'Full-stack printing service — shipped to production',
      detail:
          'Built a full-stack printing service web application with complex user roles, company management, and dashboard analytics. Deployed live on Firebase Hosting. One of the most technically complex projects to date — multi-role auth, real-time Firestore, and custom analytics dashboard.',
      skills: ['Flutter Web', 'Cloud Firestore', 'Firebase Hosting', 'Auth'],
      url: 'https://mo27-1bdd8.web.app/',
    ),
    TimelineEvent(
      date: 'Dec 2024',
      sortDate: DateTime(2024, 12),
      type: TimelineEventType.certification,
      title: 'GitHub Professional Cert',
      company: 'GitHub',
      summary: 'Career Essentials certification',
      detail:
          'Completed the Career Essentials in GitHub Professional Certificate covering modern development workflows, pull requests, GitHub Actions, and open source contribution.',
      skills: ['Git', 'GitHub', 'Version Control', 'CI/CD'],
    ),
    TimelineEvent(
      date: 'Dec 2024',
      sortDate: DateTime(2024, 12, 15),
      type: TimelineEventType.project,
      title: 'Local DNS + Docker',
      company: 'Personal Project',
      summary: 'Pi-hole and Unbound on home server',
      detail:
          'Containerised a DNS-based ad-blocking solution using Docker and Portainer running on a personal home server. Pi-hole for DNS-level ad blocking, Unbound for recursive resolution. Server runs 24/7. First real infrastructure project — demonstrates self-hosted systems knowledge.',
      skills: ['Docker', 'Linux', 'Networking', 'Server Management'],
    ),
    TimelineEvent(
      date: 'Sep 2025',
      sortDate: DateTime(2025, 9),
      type: TimelineEventType.project,
      title: 'Exquisite Funeral Planner',
      company: '18INK Productions',
      summary: 'Active production client management app',
      detail:
          'Built a full-stack Flutter application with Cloud Firestore backend for client management in the funeral planning industry. Active production app used by real clients. Demonstrates ability to deliver sensitive, professional software for non-technical end users.',
      skills: const ['Flutter', 'Cloud Firestore', 'Firebase Auth', 'UI/UX'],
    ),
    TimelineEvent(
      date: 'Dec 2025',
      sortDate: DateTime(2025, 12),
      type: TimelineEventType.education,
      title: 'Matric Completed',
      company: 'Hoerskool Noordheuwel',
      summary: 'Finished school while already working professionally',
      detail:
          'Completed the National Senior Certificate with 4 distinctions and an 82% average while balancing school, hospitality work, and professional software engineering responsibilities.',
      skills: const ['IT', 'Mathematics', 'Accounting', 'CAT'],
    ),
    TimelineEvent(
      date: 'Jan 2026',
      sortDate: DateTime(2026, 1),
      type: TimelineEventType.education,
      title: 'BSc Information Technology',
      company: 'North-West University',
      summary: 'University begins — currently enrolled',
      detail:
          'Currently enrolled in a Bachelor of Science in Information Technology at North-West University (NWU). Studying while continuing part-time remote work at 18INK Productions. Pursuing formal academic grounding alongside 3+ years of professional experience.',
      skills: ['Computer Science', 'Information Systems', 'Networking'],
    ),
  ];
}

