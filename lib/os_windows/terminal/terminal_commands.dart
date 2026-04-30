import 'package:portfolio/data/file_system_data.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/os_windows/terminal/terminal_controller.dart';
import 'package:get/get.dart';

class TerminalCommands {
  TerminalCommands._();

  static List<TerminalLine> process(
    String command,
    TerminalController terminal,
  ) {
    final lower = command.toLowerCase().trim();

    // ── ECHO ──────────────────────────────────────────────
    if (lower.startsWith('echo ')) {
      final text = command.substring(5);
      return [_out(text)];
    }

    // ── LS ────────────────────────────────────────────────
    if (lower == 'ls' || lower == 'ls -la') {
      return _ls(terminal, fancy: lower == 'ls -la');
    }

    if (lower.startsWith('ls ')) {
      final target = command.substring(3).trim();
      return _lsTarget(terminal, target);
    }

    // ── CAT ───────────────────────────────────────────────
    if (lower.startsWith('cat ')) {
      final fileName = command.substring(4).trim();
      return _cat(terminal, fileName);
    }

    // ── OPEN ──────────────────────────────────────────────
    if (lower.startsWith('open ')) {
      return _open(lower.substring(5).trim());
    }

    // ── MAN ───────────────────────────────────────────────
    if (lower == 'man') {
      return [
        _out('Usage: man [command]'),
        _out('       man -a          — list all commands'),
        _out(''),
        _out('Example: man ssh'),
      ];
    }

    if (lower == 'man -a') {
      return _manAll();
    }

    if (lower.startsWith('man ')) {
      return _man(lower.substring(4).trim());
    }

    if (lower.startsWith('sudo')) {
      return [_err('sudo: command not permitted outside of apt update')];
    }

    // ── PORTFOLIO COMMANDS ────────────────────────────────
    switch (lower) {
      case 'help':
        return _help();
      case 'whoami':
        return _whoami();
      case 'cv -view':
      case 'cat cv.txt':
        return _cv();
      case 'projects -list':
        return _projects();
      case 'experience -list':
        return _experience();
      case 'education -list':
        return _education();
      case 'contact':
        return _contact();
      case 'skills -list':
        return _skills();
      case 'certifications -list':
        return _certifications();
      case 'neofetch':
        return _neofetch();
      default:
        return [_err('command not found: $command — type "help" or "man -a"')];
    }
  }

  // ─── HELP ─────────────────────────────────────────────────
  static List<TerminalLine> _help() => [
    _out('Essential commands:'),
    _out(''),
    _out('  whoami              — who am I'),
    _out('  cv -view            — full CV'),
    _out('  projects -list      — my projects'),
    _out('  contact             — contact info'),
    _out('  ssh [site]          — connect to a profile'),
    _out('  open [app]          — open an OS application'),
    _out('  neofetch            — system info'),
    _out('  clear               — clear terminal'),
    _out(''),
    _out('Type "man -a" for the full command list.'),
  ];

  // ─── MAN ──────────────────────────────────────────────────
  static List<TerminalLine> _manAll() => [
    _out('All available commands:'),
    _out(''),
    _out('  PORTFOLIO'),
    _out('  whoami              — personal info and bio'),
    _out('  cv -view            — full CV output'),
    _out('  projects -list      — all projects'),
    _out('  experience -list    — work experience'),
    _out('  education -list     — education history'),
    _out('  skills -list        — skills with progress bars'),
    _out('  certifications -list — certifications'),
    _out('  contact             — contact info'),
    _out(''),
    _out('  FILE SYSTEM'),
    _out('  ls                  — list current directory'),
    _out('  ls [folder]         — list specific folder'),
    _out('  ls -la              — list with permissions'),
    _out('  cd [folder]         — change directory'),
    _out('  cd ..               — go up one level'),
    _out('  cd ~                — go to root'),
    _out('  cat [file]          — read a file'),
    _out('  cat cv.txt          — alias for cv -view'),
    _out(''),
    _out('  NAVIGATION'),
    _out('  ssh [site]          — connect to a profile'),
    _out('  open [app]          — open an OS application'),
    _out('  ping [site]         — ping a profile'),
    _out(''),
    _out('  SYSTEM'),
    _out('  sudo apt update     — fetch portfolio data'),
    _out('  neofetch            — system info'),
    _out('  echo [text]         — print text'),
    _out('  man [command]       — command manual'),
    _out('  man -a              — this list'),
    _out('  help                — essential commands'),
    _out('  clear               — clear terminal'),
  ];

  static List<TerminalLine> _man(String command) {
    switch (command) {
      case 'ssh':
        return [
          _out('SSH — Connect to a remote profile'),
          _out(''),
          _out('Usage: ssh [target]'),
          _out(''),
          _out('Available targets:'),
          _out('  ssh linkedin        — open LinkedIn profile'),
          _out('  ssh github          — open GitHub profile'),
          _out('  ssh fiverr          — open Fiverr profile'),
        ];
      case 'open':
        return [
          _out('OPEN — Open an OS application'),
          _out(''),
          _out('Usage: open [app]'),
          _out(''),
          _out('Available apps:'),
          _out('  open vault          — open Vault file explorer'),
          _out('  open browser        — open Browser'),
        ];
      case 'cd':
        return [
          _out('CD — Change directory'),
          _out(''),
          _out('Usage: cd [folder]'),
          _out('       cd ..          — go up one level'),
          _out('       cd ~           — go to root'),
          _out(''),
          _out('Available folders from root:'),
          ...FileSystemData.root.subFolders.map((f) => _out('  ${f.name}')),
        ];
      case 'ls':
        return [
          _out('LS — List directory contents'),
          _out(''),
          _out('Usage: ls'),
          _out('       ls [folder]    — list specific folder'),
          _out('       ls -la         — list with permissions'),
        ];
      case 'cat':
        return [
          _out('CAT — Read file contents'),
          _out(''),
          _out('Usage: cat [filename]'),
          _out(''),
          _out('Example: cat 18INK_Productions.txt'),
          _out('         cat cv.txt (alias for cv -view)'),
        ];
      case 'sudo':
        return [
          _out('SUDO — Superuser commands'),
          _out(''),
          _out('Usage: sudo apt update'),
          _out(''),
          _out('Only apt update is permitted.'),
        ];
      case 'ping':
        return [
          _out('PING — Ping a profile'),
          _out(''),
          _out('Usage: ping [target]'),
          _out(''),
          _out('Available targets:'),
          _out('  ping linkedin'),
          _out('  ping github'),
          _out('  ping fiverr'),
        ];
      case 'neofetch':
        return [
          _out('NEOFETCH — Display system information'),
          _out(''),
          _out('Usage: neofetch'),
          _out(''),
          _out('Displays ASCII logo and OS info side by side.'),
        ];
      default:
        return [_err('man: no manual entry for $command')];
    }
  }

  // ─── LS ───────────────────────────────────────────────────
  static List<TerminalLine> _ls(
    TerminalController terminal, {
    bool fancy = false,
  }) {
    final folder = terminal.currentFolder;
    final lines = <TerminalLine>[];

    if (fancy) {
      lines.add(
        _out('total ${folder.subFolders.length + folder.files.length}'),
      );
      lines.add(_out('drwxr-xr-x  tiaan  tiaan  ./'));
      if (terminal.currentPath.isNotEmpty) {
        lines.add(_out('drwxr-xr-x  tiaan  tiaan  ../'));
      }
      for (final f in folder.subFolders) {
        lines.add(_out('drwxr-xr-x  tiaan  tiaan  ${f.name}/'));
      }
      for (final f in folder.files) {
        lines.add(_out('-rw-r--r--  tiaan  tiaan  ${f.name}'));
      }
    } else {
      if (folder.subFolders.isNotEmpty) {
        lines.add(
          _out(folder.subFolders.map((f) => '${f.name}/').join('    ')),
        );
      }
      if (folder.files.isNotEmpty) {
        lines.add(_out(folder.files.map((f) => f.name).join('    ')));
      }
      if (folder.subFolders.isEmpty && folder.files.isEmpty) {
        lines.add(_out('(empty)'));
      }
    }

    return lines;
  }

  static List<TerminalLine> _lsTarget(
    TerminalController terminal,
    String target,
  ) {
    final folder = terminal.currentFolder;
    final match = folder.subFolders.firstWhereOrNull(
      (f) => f.name.toLowerCase() == target.toLowerCase(),
    );

    if (match == null) {
      return [_err('ls: $target: No such directory')];
    }

    final lines = <TerminalLine>[];
    for (final f in match.subFolders) {
      lines.add(_out('${f.name}/'));
    }
    for (final f in match.files) {
      lines.add(_out(f.name));
    }
    if (match.subFolders.isEmpty && match.files.isEmpty) {
      lines.add(_out('(empty)'));
    }
    return lines;
  }

  // ─── CAT ──────────────────────────────────────────────────
  static List<TerminalLine> _cat(TerminalController terminal, String fileName) {
    final folder = terminal.currentFolder;
    final file = folder.files.firstWhereOrNull(
      (f) => f.name.toLowerCase() == fileName.toLowerCase(),
    );

    if (file == null) {
      return [_err('cat: $fileName: No such file')];
    }

    if (file.imagePath != null) {
      return [
        _out('${file.name}: image file'),
        _out('Open in Vault to view this certificate.'),
      ];
    }

    final lines = file.content.split('\n');
    return lines.map((l) => _out(l)).toList();
  }

  // ─── OPEN ─────────────────────────────────────────────────
  static List<TerminalLine> _open(String app) {
    final desktop = Get.find<DesktopController>();

    switch (app) {
      case 'vault':
        desktop.toggleWindow('vault');
        return [_out('Opening Vault...')];
      case 'browser':
        desktop.toggleWindow('browser');
        return [_out('Opening Browser...')];
      default:
        return [
          _err('open: $app: Application not found'),
          _out('Available: open vault | open browser'),
        ];
    }
  }

  // ─── PORTFOLIO ────────────────────────────────────────────
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
    _out(''),
    _out('Tip: type "ssh linkedin" to connect directly.'),
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
      'Shell    terminal v2.0',
      'Theme    Midnight Hacker',
      'Font     Oxanium / JetBrains Mono',
      'Stack    Flutter · Firebase · Dart',
      'Role     ${PortfolioData.role}',
      'Uni      ${PortfolioData.university}',
      'Status   ${PortfolioData.status}',
      '',
      '███ ███ ███ ███ ███',
    ];

    final lines = <TerminalLine>[];
    final maxLines = logo.length > info.length ? logo.length : info.length;

    for (int i = 0; i < maxLines; i++) {
      final logoLine = i < logo.length ? logo[i] : ''.padRight(30);
      final infoLine = i < info.length ? info[i] : '';
      lines.add(TerminalLine('$logoLine  $infoLine', TerminalLineType.output));
    }

    return lines;
  }

  // ─── HELPERS ──────────────────────────────────────────────
  static TerminalLine _out(String text) =>
      TerminalLine(text, TerminalLineType.output);

  static TerminalLine _err(String text) =>
      TerminalLine(text, TerminalLineType.error);
}
