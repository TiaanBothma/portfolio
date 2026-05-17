class TechDecision {
  final String decision;
  final String reasoning;

  const TechDecision({required this.decision, required this.reasoning});
}

class CaseStudy {
  final String projectName;
  final String period;
  final List<String> techStack;
  final String? liveUrl;
  final String problem;
  final String constraints;
  final String solution;
  final List<TechDecision> techDecisions;
  final String outcome;
  final String learned;

  const CaseStudy({
    required this.projectName,
    required this.period,
    required this.techStack,
    required this.liveUrl,
    required this.problem,
    required this.constraints,
    required this.solution,
    required this.techDecisions,
    required this.outcome,
    required this.learned,
  });
}

class CaseStudiesData {
  CaseStudiesData._();

  static const List<CaseStudy> all = [
    CaseStudy(
      projectName: 'MO27 Portal',
      period: 'Jun 2024 - Jan 2025',
      techStack: ['Flutter', 'Firebase', 'Firestore', 'GetX', 'Web'],
      liveUrl: 'https://mo27-1bdd8.web.app/',
      problem:
          'MO27 needed a digital portal for a printing service where customers, company users, and administrators could work through the same system without mixing responsibilities. The goal was not just to display information, but to support real operations with roles, records, and a clear workflow.',
      constraints:
          'The project had to be built by a small team, move quickly, and remain simple enough for non-technical users. It also needed browser access, Firebase hosting, role-aware UI, and a data structure that could change as the client refined the workflow.',
      solution:
          'I built a Flutter Web portal backed by Cloud Firestore. The app separates user roles, company data, and operational dashboards so the same codebase can serve multiple user types. The UI was kept direct and task-focused because the product is operational, not decorative.',
      techDecisions: [
        TechDecision(
          decision: 'Flutter Web over a traditional website stack',
          reasoning:
              'Flutter let me reuse my strongest production skill while building a desktop-like business interface with consistent components, routing, and state.',
        ),
        TechDecision(
          decision: 'Firestore over SQL for the first production version',
          reasoning:
              'The data model was still evolving. Firestore made it easier to ship fast, iterate on nested company/user structures, and avoid managing custom server infrastructure.',
        ),
        TechDecision(
          decision: 'GetX for state and navigation',
          reasoning:
              'GetX matched the rest of my Flutter workflow and kept controller logic compact for role state, screen changes, and reactive dashboard values.',
        ),
      ],
      outcome:
          'The portal reached a live hosted version and became the strongest example of my ability to build a real client-facing web app with authentication-style flows, role separation, data management, and deployment.',
      learned:
          'The biggest lesson was that production apps are mostly about clarity. The difficult part was not drawing screens, it was keeping roles, data ownership, and user expectations understandable as the project changed.',
    ),
    CaseStudy(
      projectName: 'Exquisite Funeral Planner',
      period: 'Sep 2025 - Present',
      techStack: ['Flutter', 'Firestore', 'Client Management', 'UI Design'],
      liveUrl: null,
      problem:
          'The client needed a structured way to manage sensitive funeral planning information without relying on scattered notes, messages, and manual tracking. The app had to feel calm and dependable because the domain is emotionally serious.',
      constraints:
          'The app is active professional work, so changes must be careful. Data has to be readable, forms must be simple, and the interface cannot feel playful or over-designed. The system also has to be maintainable as the client discovers new needs.',
      solution:
          'I built a full-stack Flutter application with Firestore as the backend. The focus is on clean client records, predictable navigation, and screens that help the user enter and review information without unnecessary friction.',
      techDecisions: [
        TechDecision(
          decision: 'Firestore document structure for client records',
          reasoning:
              'Client planning data fits naturally into document-based records that can grow as more fields and sections are added.',
        ),
        TechDecision(
          decision: 'Restrained UI instead of a decorative interface',
          reasoning:
              'The subject matter requires trust. I kept the visual language quiet, organized, and practical.',
        ),
        TechDecision(
          decision: 'Single Flutter codebase',
          reasoning:
              'A unified codebase keeps delivery faster and allows the app to expand to more form-heavy workflows without splitting development effort.',
        ),
      ],
      outcome:
          'The project is ongoing and represents real production responsibility: maintaining client work, adjusting to changing requirements, and building software for a sensitive real-world workflow.',
      learned:
          'I learned to design with more empathy. Good software is not always loud or impressive on the surface. Sometimes the best engineering choice is to make the next step obvious and reduce stress for the person using it.',
    ),
    CaseStudy(
      projectName: 'Local DNS with Docker',
      period: 'Dec 2024',
      techStack: ['Docker', 'Linux', 'Pi-hole', 'Unbound', 'Portainer'],
      liveUrl: null,
      problem:
          'I wanted more control over my home network and a deeper understanding of DNS, containers, and self-hosted infrastructure. Instead of only reading about networking, I wanted a real service running on my own hardware.',
      constraints:
          'The system had to run at home, be easy to inspect, and stay stable enough that it would not break normal network usage. It also needed to teach me container management without hiding everything behind a managed platform.',
      solution:
          'I set up Pi-hole and Unbound in Docker containers and managed them through Portainer. Pi-hole handles network-level ad blocking while Unbound acts as a recursive DNS resolver. The result is a practical home-server setup with real operational value.',
      techDecisions: [
        TechDecision(
          decision: 'Docker containers instead of direct host installs',
          reasoning:
              'Containers made the services easier to isolate, restart, inspect, and move without turning the server into a fragile one-off setup.',
        ),
        TechDecision(
          decision: 'Unbound as the upstream resolver',
          reasoning:
              'Using Unbound helped me understand recursive DNS and reduced reliance on a single public DNS provider.',
        ),
        TechDecision(
          decision: 'Portainer for visibility',
          reasoning:
              'Portainer gave me a clear way to inspect containers, logs, and status while still learning the underlying Docker concepts.',
        ),
      ],
      outcome:
          'The project proved that I can work outside normal app development and understand infrastructure concepts such as DNS, ports, containers, service health, and network-level tooling.',
      learned:
          'I learned that infrastructure rewards patience. A tiny misconfiguration can look like the whole internet is broken. Debugging DNS taught me to move slowly, verify assumptions, and understand the layer I am changing.',
    ),
  ];
}
