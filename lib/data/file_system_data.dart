import 'package:portfolio/data/portfolio_data.dart';

class VaultFile {
  final String name;
  final String content;

  const VaultFile({required this.name, required this.content});
}

class VaultFolder {
  final String name;
  final List<VaultFolder> subFolders;
  final List<VaultFile> files;

  const VaultFolder({
    required this.name,
    this.subFolders = const [],
    this.files = const [],
  });
}

class FileSystemData {
  FileSystemData._();

  static final VaultFolder root = VaultFolder(
    name: 'Tiaan Bothma OS',
    subFolders: [_experience, _projects, _education, _certifications, _system],
  );

  // === EXPERIENCE ===========================================
  static final VaultFolder _experience = VaultFolder(
    name: 'Experience',
    files: [
      VaultFile(
        name: '18INK_Productions.txt',
        content: '''POSITION:  Software Engineer
COMPANY:   18INK Productions (Pty)
TYPE:      Part-time
PERIOD:    Feb 2024 - Present
LOCATION:  South Africa - Remote
=========================================

ABOUT THE ROLE:
Worked during Grade 11, 12 and University developing
full-stack production applications for real clients.

RESPONSIBILITIES:
  - Developed full-stack websites using Flutter
  - Feature implementation for managing stock,
    facilitating user orders, user authentication
  - Implemented and designed Cloud Firestore for a
    secure and fast database system
  - Integrated Firebase Storage for media handling
  - Optimizing performance with state management
  - Enhancing skills in full-stack development,
    UI/UX design, and agile methodologies

SKILLS USED:
  Flutter - Cloud Firestore - Firebase - Dart
  UI/UX Design - State Management - Git
''',
      ),
      VaultFile(
        name: 'MyEncore_CC.txt',
        content: '''POSITION:  Full Stack Developer
COMPANY:   MyEncore CC
TYPE:      Part-time
PERIOD:    Feb 2024 - Jun 2024
LOCATION:  South Africa - Remote
=========================================

ABOUT THE ROLE:
Worked during Grade 11 developing a comprehensive
school application used by real students and staff.

RESPONSIBILITIES:
  - Developed a comprehensive school app using Flutter
  - Designed user interfaces and experiences for
    optimal usability
  - Managed databases to store and retrieve information
  - Collaborated with a team to integrate modules
    and ensure seamless operation
  - Conducted testing and debugging to maintain
    high app performance and reliability
  - Regularly updated and improved app features
    based on user feedback

SKILLS USED:
  Flutter - Firebase - Full-Stack Development
  UI/UX Design - Team Collaboration - Testing
''',
      ),
      VaultFile(
        name: 'Fiverr.txt',
        content: '''POSITION:  Software Developer
COMPANY:   Fiverr
TYPE:      Part-time / Freelance
PERIOD:    Dec 2022 - Sep 2024
LOCATION:  Remote
=========================================

ABOUT THE ROLE:
Started freelancing in Grade 10 - delivering custom
Flutter applications and games to international clients.

RESPONSIBILITIES:
  - Delivered custom Flutter applications for clients
  - Built small games and interactive applications
    using Python and Unity
  - Communicated with clients to gather requirements
    and deliver on expectations
  - Managed deadlines and handled multiple projects
    simultaneously
  - Strengthened client communication and
    problem-solving skills

SKILLS USED:
  Flutter - Python - Unity - C# - Client Communication
  Project Management - Firebase - Dart
''',
      ),
      VaultFile(
        name: 'Bergvallei_Estates.txt',
        content: '''POSITION:  Waiter
COMPANY:   Bergvallei Estates
TYPE:      Part-time
PERIOD:    Nov 2023 - Nov 2025
LOCATION:  Krugersdorp, Gauteng - On-site
=========================================

ABOUT THE ROLE:
Worked during Grade 11 and 12 in a fast-paced
hospitality environment alongside academic studies.

RESPONSIBILITIES:
  - Provided customer service in a fast-paced
    environment
  - Developed strong multitasking and communication
    skills
  - Worked effectively as part of a team under
    pressure

SKILLS USED:
  Teamwork - Communication - Problem Solving
  Multitasking - Customer Service
''',
      ),
    ],
  );

  // === PROJECTS =============================================
  static final VaultFolder _projects = VaultFolder(
    name: 'Projects',
    files: [
      VaultFile(
        name: 'Exquisite_Funeral_Planner.txt',
        content: '''PROJECT:   Exquisite Funeral Planner
COMPANY:   18INK Productions (Pty)
PERIOD:    Sep 2025 - Present
STATUS:    Active
=========================================

DESCRIPTION:
Full-stack Flutter application with Cloud Firestore
backend built for client management in the funeral
planning industry.

FEATURES:
  - Client record management and tracking
  - Real-time data sync with Cloud Firestore
  - User authentication and role management
  - Document and media storage via Firebase Storage
  - Clean and professional UI/UX design

TECH STACK:
  Flutter - Cloud Firestore - Firebase Auth
  Firebase Storage - Dart - GetX
''',
      ),
      VaultFile(
        name: 'MO27_Portal.txt',
        content: '''PROJECT:   MO27 Portal
COMPANY:   18INK Productions (Pty)
PERIOD:    Jun 2024 - Jan 2025
STATUS:    Completed
URL:       https://mo27-1bdd8.web.app/
=========================================

DESCRIPTION:
Full-stack printing service web application with
complex user roles, company management features,
and dashboard analytics for business insights.

FEATURES:
  - Complex multi-role user system
  - Company and order management
  - Dashboard with statistical analytics
  - Real-time data with Cloud Firestore
  - Flutter Web deployment via Firebase Hosting

TECH STACK:
  Flutter - Cloud Firestore - Firebase Auth
  Firebase Hosting - Dart - Flutter Web
''',
      ),
      VaultFile(
        name: 'Local_DNS_Docker.txt',
        content: '''PROJECT:   Local DNS with Docker: Pi-hole + Unbound
PERIOD:    Dec 2024
STATUS:    Completed (Personal Project)
=========================================

DESCRIPTION:
Containerized DNS-based ad-blocking solution running
on a personal home server using Docker and Portainer.
Built for personal learning and home network management.

SETUP:
  - Pi-hole for DNS-level ad blocking
  - Unbound for recursive DNS resolution
  - Docker containers managed via Portainer
  - Running on local home server 24/7

WHAT I LEARNED:
  - Docker containerization and networking
  - DNS architecture and resolution chain
  - Server management and uptime monitoring
  - Network administration on a local level

TECH STACK:
  Docker - Portainer - Pi-hole - Unbound
  Linux - Server Management - Networking
''',
      ),
    ],
  );

  // === EDUCATION ============================================
  static final VaultFolder _education = VaultFolder(
    name: 'Education',
    files: [
      VaultFile(
        name: 'North_West_University.txt',
        content: '''INSTITUTION: North-West University (NWU)
DEGREE:      Bachelor of Science - Information Technology
PERIOD:      Jan 2026 - Dec 2029
STATUS:      Currently Enrolled
=========================================

ABOUT:
Currently pursuing a BSc in Information Technology
at NWU while working part-time as a remote software
engineer. Balancing academic study with real-world
professional development.

FOCUS AREAS:
  - Software Development
  - Information Systems
  - Computer Networks
  - Database Management
  - Cybersecurity Fundamentals
''',
      ),
      VaultFile(
        name: 'Hoerskool_Noordheuwel.txt',
        content: '''INSTITUTION: Hoërskool Noordheuwel
QUALIFICATION: National Senior Certificate (Matric)
PERIOD:      Jan 2022 - Dec 2025
STATUS:      Completed
RESULT:      4 Distinctions - 82% Average
=========================================

DISTINCTIONS:
  - Information Technology
    Top IT student - Programming - Full Stack Development

  - Computer Applications Technology
    Microsoft Excel/Word - Hardware/Software - HTML

  - Accounting
    Business Management - Financial Tracking
    Profit & Loss Ratios

  - Mathematics
    Algebra - Number Theory - Geometry - Arithmetic

ACTIVITIES:
  Rugby - Gym - Helping other students

AWARDS:
  Grade 12 Best in IT - Oct 2025
''',
      ),
    ],
  );

  // === CERTIFICATIONS =======================================
  static final VaultFolder _certifications = VaultFolder(
    name: 'Certifications',
    files: [
      VaultFile(
        name: 'Best_in_IT_Grade12.txt',
        content: '''CERTIFICATION: Grade 12 - Best in IT
ISSUER:        Hoërskool Noordheuwel
ISSUED:        October 2025
=========================================

DESCRIPTION:
Awarded the top Information Technology student
award in Grade 12 at Hoërskool Noordheuwel.

Recognized for excellence in:
  - Programming and software development
  - Full stack development concepts
  - Computer science fundamentals
  - Consistent academic performance in IT
''',
      ),
      VaultFile(
        name: 'GitHub_Professional_Certificate.txt',
        content: '''CERTIFICATION: Career Essentials in GitHub
               Professional Certificate
ISSUER:        GitHub
ISSUED:        December 2024
=========================================

DESCRIPTION:
Completed the GitHub Career Essentials professional
certification covering modern development workflows
and GitHub platform expertise.

TOPICS COVERED:
  - Version control with Git and GitHub
  - Collaborative development workflows
  - Pull requests and code review processes
  - GitHub Actions and automation
  - Repository management best practices
  - Open source contribution workflows
''',
      ),
    ],
  );

  // === SYSTEM ===============================================
  static final VaultFolder _system = VaultFolder(
    name: 'System',
    files: [
      VaultFile(
        name: 'README.txt',
        content:
            '''Welcome to Tiaan Bothma OS
${PortfolioData.version}
=========================================

Hello! Thanks for taking the time to explore.

This OS is a portfolio built entirely in Flutter Web
by Tiaan Bothma - a remote Flutter Full Stack Developer
and BSc IT student at North-West University.

HOW TO NAVIGATE:
  > Use the dock at the bottom to open apps
  > Terminal - type "help" to see all commands
  > Vault - browse files and folders like a real OS
  > Browser - visit GitHub, LinkedIn and Fiverr pages

QUICK TERMINAL COMMANDS:
  whoami           - who am I
  cv --view        - full CV in the terminal
  projects --list  - all my projects
  contact          - how to reach me
  neofetch         - system info

ABOUT THIS PROJECT:
  Built with Flutter Web - GetX - Firebase Hosting
  Every window is draggable and resizable.
  The terminal has real command history (arrow up).
  The browser renders custom-built profile pages.

=========================================
${PortfolioData.name}
${PortfolioData.role}
${PortfolioData.linkedin}
''',
      ),
     VaultFile(
  name: 'version.txt',
  content: '''Tiaan Bothma OS
Version: ${PortfolioData.version}
=========================================

CURRENT VERSION: ${PortfolioData.version}

CHANGELOG:
  v1.0.0 — Initial Release
  =======================
  + Initial Release
  + Custom OS logo designed and created
  + Terminal with full CV commands
  + Browser with tab support
  + GitHub, LinkedIn and Fiverr profile pages
  + Draggable and resizable windows
  + Mobile blocking (desktop only)

  v1.1.0 — Terminal Improvements
  ===============================
  + Neofetch command with ASCII logo
  + Terminal Command history (arrow up / down)
  + Window size improvements and constraints
  + Additional terminal commands and responses
  + Improved terminal feel and behaviour

  v1.2.0 — Pages and Navigation
  ==============================
  + Improved UI across the OS
  + Navigation to real social profiles
  + External links open in new browser tab

  v2.0.0 — Major Update
  ======================
  + Vault files and folder application
  + Improved LinkedIn page with banner
  + Improved Fiverr page with working buttons
  + Improved GitHub page with real API data
  + Notepad application for viewing text files
  + File system with folders and .txt files
  + Start menu redesigned and fully working
  + Improved overall user experience
  + Improved window sizing and feel
  + About section and system files added

=========================================
Built with Flutter Web
''',
),
    ],
  );
}
