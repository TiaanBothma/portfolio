import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/os_windows/terminal/terminal_controller.dart';

class TerminalCommands {
  TerminalCommands._();

  static List<TerminalLine> process(String command) {
    switch (command.toLowerCase()) {
      case 'help':
        return _help();
      case 'whoami':
        return _whoami();
      case 'cv --view':
        return _cv();
      case 'projects --list':
        return _projects();
      case 'experience --list':
        return _experience();
      case 'education --list':
        return _education();
      case 'contact':
        return _contact();
      case 'skills --list':
        return _skills();
      case 'certifications --list':
        return _certifications();
      case 'neofetch':
        return _neofetch();
      default:
        return [
          TerminalLine(
            'command not found: $command — type "help" for available commands',
            TerminalLineType.error,
          ),
        ];
    }
  }

  static List<TerminalLine> _help() => [
    _out('Available commands:'),
    _out('  whoami                — who am I'),
    _out('  neofetch              — system information'),
    _out('  cv --view             — full CV summary'),
    _out('  projects --list       — list my projects'),
    _out('  experience --list     — work experience'),
    _out('  education --list      — education history'),
    _out('  skills --list         — technical skills'),
    _out('  certifications --list — my certifications'),
    _out('  contact               — contact information'),
    _out('  clear                 — clear terminal'),
  ];

  static List<TerminalLine> _whoami() => [
    _out(PortfolioData.name),
    _out(PortfolioData.role),
    _out(PortfolioData.university),
    _out(PortfolioData.location),
    _out(PortfolioData.status),
    _out(''),
    _out(PortfolioData.bio),
  ];

  static List<TerminalLine> _projects() {
    final lines = [_out('Projects:')];
    for (int i = 0; i < PortfolioData.projects.length; i++) {
      final p = PortfolioData.projects[i];
      lines.add(_out('  [${i + 1}] ${p['name']} (${p['period']})'));
      lines.add(_out('      ${p['description']}'));
    }
    return lines;
  }

  static List<TerminalLine> _experience() {
    final lines = [_out('Experience:')];
    for (final e in PortfolioData.experience) {
      lines.add(_out('  ${e['title']} @ ${e['company']}'));
      lines.add(_out('  ${e['period']} · ${e['location']}'));
      lines.add(_out(''));
    }
    return lines;
  }

  static List<TerminalLine> _education() {
    final lines = [_out('Education:')];
    for (final e in PortfolioData.education) {
      lines.add(_out('  ${e['institution']}'));
      lines.add(_out('  ${e['qualification']}'));
      lines.add(_out('  ${e['period']}'));
      if (e['note'] != null) lines.add(_out('  ${e['note']}'));
      lines.add(_out(''));
    }
    return lines;
  }

  static List<TerminalLine> _skills() {
    final lines = [_out('Skills:')];
    for (final s in PortfolioData.skills) {
      final percent = ((s['level'] as double) * 100).toInt();
      final filled = (percent / 10).round();
      final bar = '${'█' * filled}${'░' * (10 - filled)}';
      lines.add(
        _out('  ${s['name'].toString().padRight(22)} [$bar] $percent%'),
      );
    }
    return lines;
  }

  static List<TerminalLine> _certifications() {
    final lines = [_out('Certifications:')];
    for (final c in PortfolioData.certifications) {
      lines.add(_out('  ${c['title']}'));
      lines.add(_out('  Issued by ${c['issuer']} · ${c['date']}'));
      lines.add(_out(''));
    }
    return lines;
  }

  static List<TerminalLine> _contact() => [
    _out('Contact:'),
    _out('  LinkedIn  — ${PortfolioData.linkedin}'),
    _out('  GitHub    — ${PortfolioData.github}'),
    _out('  Fiverr    — ${PortfolioData.fiverr}'),
  ];

  static List<TerminalLine> _cv() => [
    ..._whoami(),
    _out(''),
    ..._experience(),
    ..._education(),
    ..._skills(),
    ..._certifications(),
    ..._contact(),
  ];

  static List<TerminalLine> _neofetch() {
    const logo = [
      '           √√√√√√√                ',
      '          √       √               ',
      '          √       √               ',
      '           √√√ √√√                ',
      '              √                   ',
      '    √√√√√√√√√√√√√√√√√√√√√         ',
      '    √          √          √       ',
      '√√√√√√√√√  √√√√√√√√√  √√√√√√√√√   ',
      '√       √  √       √  √       √   ',
      '√       √  √       √  √       √   ',
      '√√√√√√√√√  √√√√√√√√√  √√√√√√√√√   ',
    ];

    final info = [
      '${PortfolioData.name} @ Portfolio OS',
      '─────────────────────────────',
      'OS       Tiaan Bothma OS ${PortfolioData.version}',
      'Shell    terminal',
      'Theme    Midnight',
      'Font     Oxanium / JetBrains Mono',
      'Stack    Flutter - Firebase - CyberSecurity',
      'Role     ${PortfolioData.role}',
      'Uni      ${PortfolioData.university}',
      'Status   ${PortfolioData.status}',
    ];

    final lines = <TerminalLine>[];
    final maxLines = logo.length > info.length ? logo.length : info.length;

    for (int i = 0; i < maxLines; i++) {
      final logoLine = i < logo.length ? logo[i] : ''.padRight(23);
      final infoLine = i < info.length ? info[i] : '';
      lines.add(TerminalLine('$logoLine  $infoLine', TerminalLineType.output));
    }

    return lines;
  }

  static TerminalLine _out(String text) =>
      TerminalLine(text, TerminalLineType.output);
}
