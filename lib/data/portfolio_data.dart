class PortfolioData {
  PortfolioData._();

  static const String version = 'v1.1.0';
  // Personal
  static const String name = 'Tiaan Bothma';
  static const String role = 'Flutter Full Stack Developer';
  static const String university = 'NWU — BSc IT';
  static const String location = 'South Africa';
  static const String status = 'Remote: Available';
  static const String bio =
      'Remote-working junior software developer with experience building and maintaining Flutter applications. Skilled in UI design, backend systems, and full-stack development using Cloud Firestore.';

  // Contact
  static const String linkedin = 'linkedin.com/in/tiaan-bothma-0b1bb3283/';
  static const String github = 'github.com/TiaanBothma';
  static const String fiverr = 'fiverr.com/s/xX3GEzD';

  // Experience
  static const List<Map<String, String>> experience = [
    {
      'title': 'Software Engineer',
      'company': '18INK Productions (Pty)',
      'type': 'Part-time',
      'period': 'Feb 2024 - Present',
      'location': 'South Africa · Remote',
    },
    {
      'title': 'Full Stack Developer',
      'company': 'MyEncore CC',
      'type': 'Part-time',
      'period': 'Feb 2024 - Jun 2024',
      'location': 'South Africa · Remote',
    },
    {
      'title': 'Software Developer',
      'company': 'Fiverr',
      'type': 'Part-time',
      'period': 'Dec 2022 - Sep 2024',
      'location': 'Remote',
    },
    {
      'title': 'Waiter',
      'company': 'Bergvallei Estates',
      'type': 'Part-time',
      'period': 'Nov 2023 - Nov 2025',
      'location': 'Krugersdorp, Gauteng',
    },
  ];

  // Projects
  static const List<Map<String, String>> projects = [
    {
      'name': 'Exquisite Funeral Planner',
      'period': 'Sep 2025 - Present',
      'company': '18INK Productions (Pty)',
      'description':
          'Full-stack Flutter app with Cloud Firestore backend for client management.',
      'skills':
          'Cloud Firestore · Full-Stack Development · Front-End Development',
    },
    {
      'name': 'MO27 Portal',
      'period': 'Jun 2024 - Jan 2025',
      'company': '18INK Productions (Pty)',
      'description':
          'Full-stack printing service app with complex user roles, company management, and dashboard analytics.',
      'url': 'https://mo27-1bdd8.web.app/',
      'skills': 'Cloud Firestore · Full-Stack Development · Flutter',
    },
    {
      'name': 'Local DNS with Docker',
      'period': 'Dec 2024',
      'company': 'Personal',
      'description':
          'Containerized DNS-based ad-blocking solution using Docker and Portainer for personal learning.',
      'skills': 'Docker · Server Management',
    },
  ];

  // Education
  static const List<Map<String, String>> education = [
    {
      'institution': 'North-West University',
      'qualification': 'Bachelor of Science — Information Technology',
      'period': 'Jan 2026 - Dec 2029',
    },
    {
      'institution': 'Hoërskool Noordheuwel',
      'qualification': 'National Senior Certificate',
      'period': 'Jan 2022 - Dec 2025',
      'note': '4 Distinctions · 82% Average',
    },
  ];

  // Skills
  static const List<Map<String, dynamic>> skills = [
    {'name': 'Flutter', 'level': 0.95},
    {'name': 'Firebase', 'level': 0.95},
    {'name': 'Docker', 'level': 0.60},
    {'name': 'Python', 'level': 0.70},
  ];

  // Certifications
  static const List<Map<String, String>> certifications = [
    {
      'title': 'Grade 12: Best in IT',
      'issuer': 'Hoërskool Noordheuwel',
      'date': 'Oct 2025',
    },
    {
      'title': 'Career Essentials in GitHub Professional Certificate',
      'issuer': 'GitHub',
      'date': 'Dec 2024',
    },
  ];
}
