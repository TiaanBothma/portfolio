import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/file_system_data.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/os_windows/terminal/terminal_commands.dart';
import 'package:web/web.dart' as web;

class TerminalController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController inputController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final outputLines = <TerminalLine>[].obs;
  final currentInput = ''.obs;

  // Command history
  final _commandHistory = <String>[];
  int _historyIndex = -1;

  // File system navigation
  final currentPath = <String>[].obs;
  VaultFolder get currentFolder {
    VaultFolder folder = FileSystemData.root;
    for (final segment in currentPath) {
      folder = folder.subFolders.firstWhere(
        (f) => f.name.toLowerCase() == segment.toLowerCase(),
        orElse: () => folder,
      );
    }
    return folder;
  }

  String get promptPath {
    if (currentPath.isEmpty) return '~';
    return '~/${currentPath.join('/')}';
  }

  String get prompt => 'tiaan@portfolio:$promptPath\$';

  @override
  void onInit() {
    super.onInit();
    focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          navigateHistory(true);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          navigateHistory(false);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.tab) {
          _handleTabCompletion();
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
    _printWelcome();
  }

  @override
  void onClose() {
    scrollController.dispose();
    inputController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  // ─── WELCOME ──────────────────────────────────────────────
  void _printWelcome() {
    outputLines.addAll([
      TerminalLine('Welcome to Tiaan Bothma OS', TerminalLineType.output),
      TerminalLine(
        'Type "help" for essential commands or "man -a" for all commands.',
        TerminalLineType.output,
      ),
      TerminalLine('', TerminalLineType.output),
    ]);
  }

  // ─── INPUT ────────────────────────────────────────────────
  void onInputChanged(String value) {
    currentInput.value = value;
  }

  void onSubmit() {
    final command = currentInput.value.trim();
    outputLines.add(TerminalLine('$prompt $command', TerminalLineType.command));

    if (command.isNotEmpty) {
      _commandHistory.add(command);
      _historyIndex = _commandHistory.length;
      _processCommand(command);
    }

    inputController.clear();
    currentInput.value = '';
    _scrollToBottom();
  }

  // ─── COMMAND PROCESSING ───────────────────────────────────
  void _processCommand(String raw) async {
    final command = raw.trim();
    final lower = command.toLowerCase();

    if (lower == 'clear') {
      outputLines.clear();
      return;
    }

    if (lower == 'cd ~' || lower == 'cd') {
      currentPath.clear();
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    if (lower == 'cd ..') {
      if (currentPath.isNotEmpty) currentPath.removeLast();
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    if (lower.startsWith('cd ')) {
      final target = command.substring(3).trim();
      final match = currentFolder.subFolders.firstWhereOrNull(
        (f) => f.name.toLowerCase() == target.toLowerCase(),
      );
      if (match != null) {
        currentPath.add(match.name);
      } else {
        outputLines.add(
          TerminalLine(
            'cd: $target: No such directory',
            TerminalLineType.error,
          ),
        );
      }
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    // Async commands — handle delay internally
    if (lower == 'sudo apt update') {
      await _sudoAptUpdate();
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    if (lower.startsWith('ping ')) {
      await _ping(lower.substring(5).trim());
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    if (lower.startsWith('ssh ')) {
      await _ssh(lower.substring(4).trim());
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    // All other commands — instant
    final result = TerminalCommands.process(command, this);
    outputLines.addAll(result);
    outputLines.add(TerminalLine('', TerminalLineType.output));
    _scrollToBottom();
  }

  Future<void> addLinesWithDelay(
    List<TerminalLine> lines, {
    Duration delay = const Duration(milliseconds: 80),
  }) async {
    for (final line in lines) {
      await Future.delayed(delay);
      outputLines.add(line);
      _scrollToBottom();
    }
  }

  // ─── TAB COMPLETION ───────────────────────────────────────
  void _handleTabCompletion() {
    final input = currentInput.value.trim();
    if (input.isEmpty) return;

    final parts = input.split(' ');
    final firstWord = parts[0].toLowerCase();

    // Complete cd or cat with folder/file names
    if ((firstWord == 'cd' || firstWord == 'cat') && parts.length >= 2) {
      final partial = parts.last.toLowerCase();
      final candidates = firstWord == 'cd'
          ? currentFolder.subFolders.map((f) => f.name)
          : currentFolder.files.map((f) => f.name);

      final matches = candidates
          .where((c) => c.toLowerCase().startsWith(partial))
          .toList();

      if (matches.length == 1) {
        final completed =
            '${parts.sublist(0, parts.length - 1).join(' ')} ${matches[0]}';
        inputController.value = TextEditingValue(
          text: completed,
          selection: TextSelection.collapsed(offset: completed.length),
        );
        currentInput.value = completed;
      } else if (matches.length > 1) {
        outputLines.add(
          TerminalLine(matches.join('    '), TerminalLineType.output),
        );
        _scrollToBottom();
      }
      return;
    }

    // Complete ssh
    if (firstWord == 'ssh' && parts.length >= 2) {
      final partial = parts.last.toLowerCase();
      final sshTargets = ['linkedin', 'github', 'fiverr'];
      final matches = sshTargets.where((t) => t.startsWith(partial)).toList();

      if (matches.length == 1) {
        final completed = 'ssh ${matches[0]}';
        inputController.value = TextEditingValue(
          text: completed,
          selection: TextSelection.collapsed(offset: completed.length),
        );
        currentInput.value = completed;
      } else if (matches.length > 1) {
        outputLines.add(
          TerminalLine(matches.join('    '), TerminalLineType.output),
        );
        _scrollToBottom();
      }
      return;
    }

    // Complete open
    if (firstWord == 'open' && parts.length >= 2) {
      final partial = parts.last.toLowerCase();
      final openTargets = ['vault', 'browser', 'terminal'];
      final matches = openTargets.where((t) => t.startsWith(partial)).toList();

      if (matches.length == 1) {
        final completed = 'open ${matches[0]}';
        inputController.value = TextEditingValue(
          text: completed,
          selection: TextSelection.collapsed(offset: completed.length),
        );
        currentInput.value = completed;
      }
      return;
    }

    // Complete top-level commands
    final allCommands = [
      'help',
      'whoami',
      'cv -view',
      'projects -list',
      'experience -list',
      'education -list',
      'skills -list',
      'certifications -list',
      'contact',
      'ssh',
      'open',
      'ping',
      'echo',
      'ls',
      'cd',
      'cat',
      'neofetch',
      'sudo apt update',
      'man',
      'clear',
    ];

    final matches = allCommands
        .where((c) => c.toLowerCase().startsWith(input.toLowerCase()))
        .toList();

    if (matches.length == 1) {
      inputController.value = TextEditingValue(
        text: matches[0],
        selection: TextSelection.collapsed(offset: matches[0].length),
      );
      currentInput.value = matches[0];
    } else if (matches.length > 1) {
      outputLines.add(
        TerminalLine(matches.join('    '), TerminalLineType.output),
      );
      _scrollToBottom();
    }
  }

  // ─── HISTORY ──────────────────────────────────────────────
  void navigateHistory(bool up) {
    if (_commandHistory.isEmpty) return;

    if (up) {
      _historyIndex = (_historyIndex - 1).clamp(0, _commandHistory.length - 1);
    } else {
      _historyIndex = (_historyIndex + 1).clamp(0, _commandHistory.length);
    }

    final value = _historyIndex < _commandHistory.length
        ? _commandHistory[_historyIndex]
        : '';

    inputController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    currentInput.value = value;
  }

  // ─── SCROLL ───────────────────────────────────────────────
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── DELAYED COMMANDS ──────────────────────────────────────────────

  Future<void> _sudoAptUpdate() async {
    await addLinesWithDelay([
      TerminalLine(
        '[sudo] password for tiaan: ********',
        TerminalLineType.output,
      ),
    ], delay: const Duration(milliseconds: 600));

    await Future.delayed(const Duration(milliseconds: 400));

    await addLinesWithDelay([
      TerminalLine('', TerminalLineType.output),
      TerminalLine('Hit: github.com/TiaanBothma', TerminalLineType.output),
    ], delay: const Duration(milliseconds: 200));

    await addLinesWithDelay([
      TerminalLine(
        'Hit: linkedin.com/in/tiaan-bothma',
        TerminalLineType.output,
      ),
      TerminalLine('Hit: fiverr.com/tiaanbothma', TerminalLineType.output),
      TerminalLine('', TerminalLineType.output),
      TerminalLine('Fetching portfolio data...', TerminalLineType.output),
    ], delay: const Duration(milliseconds: 150));

    await addLinesWithDelay([
      TerminalLine(
        '  Fetching: experience        (${PortfolioData.experience.length} records)    OK',
        TerminalLineType.output,
      ),
      TerminalLine(
        '  Fetching: projects          (${PortfolioData.projects.length} records)    OK',
        TerminalLineType.output,
      ),
      TerminalLine(
        '  Fetching: certifications    (${PortfolioData.certifications.length} records)    OK',
        TerminalLineType.output,
      ),
      TerminalLine(
        '  Fetching: skills            (${PortfolioData.skills.length} records)    OK',
        TerminalLineType.output,
      ),
    ], delay: const Duration(milliseconds: 180));

    await Future.delayed(const Duration(milliseconds: 300));

    await addLinesWithDelay([
      TerminalLine('', TerminalLineType.output),
      TerminalLine('Reading package lists... Done', TerminalLineType.output),
      TerminalLine('Building dependency tree... Done', TerminalLineType.output),
      TerminalLine('', TerminalLineType.output),
      TerminalLine(
        'Tiaan Bothma OS ${PortfolioData.version} is up to date.',
        TerminalLineType.output,
      ),
      TerminalLine(
        'All packages are current. No updates available.',
        TerminalLineType.output,
      ),
    ], delay: const Duration(milliseconds: 120));
  }

  Future<void> _ping(String target) async {
    final hosts = {
      'linkedin': 'linkedin.com',
      'github': 'github.com',
      'fiverr': 'fiverr.com',
    };

    final host = hosts[target];
    if (host == null) {
      outputLines.add(
        TerminalLine('ping: $target: Host not found', TerminalLineType.error),
      );
      outputLines.add(
        TerminalLine(
          'Available: ping linkedin | ping github | ping fiverr',
          TerminalLineType.output,
        ),
      );
      return;
    }

    await addLinesWithDelay([
      TerminalLine('PING $host: 56 bytes of data', TerminalLineType.output),
    ], delay: const Duration(milliseconds: 200));

    await addLinesWithDelay([
      TerminalLine(
        '64 bytes from $host: seq=0 time=1ms',
        TerminalLineType.output,
      ),
      TerminalLine(
        '64 bytes from $host: seq=1 time=2ms',
        TerminalLineType.output,
      ),
      TerminalLine(
        '64 bytes from $host: seq=2 time=1ms',
        TerminalLineType.output,
      ),
    ], delay: const Duration(milliseconds: 500));

    await Future.delayed(const Duration(milliseconds: 300));

    await addLinesWithDelay([
      TerminalLine('', TerminalLineType.output),
      TerminalLine('--- $host ping statistics ---', TerminalLineType.output),
      TerminalLine(
        '3 packets transmitted, 3 received, 0% packet loss',
        TerminalLineType.output,
      ),
      TerminalLine('Profile is live and reachable.', TerminalLineType.output),
    ], delay: const Duration(milliseconds: 100));
  }

  Future<void> _ssh(String target) async {
    final urls = {
      'linkedin': 'https://${PortfolioData.linkedin}',
      'github': 'https://${PortfolioData.github}',
      'fiverr': 'https://${PortfolioData.fiverr}',
    };

    final url = urls[target];
    if (url == null) {
      outputLines.add(
        TerminalLine('ssh: $target: Host not found', TerminalLineType.error),
      );
      outputLines.add(
        TerminalLine(
          'Available: ssh linkedin | ssh github | ssh fiverr',
          TerminalLineType.output,
        ),
      );
      return;
    }

    await addLinesWithDelay([
      TerminalLine('Connecting to $target...', TerminalLineType.output),
    ], delay: const Duration(milliseconds: 300));

    await Future.delayed(const Duration(milliseconds: 500));

    await addLinesWithDelay([
      TerminalLine('Connection established.', TerminalLineType.output),
      TerminalLine('Opening $url', TerminalLineType.output),
    ], delay: const Duration(milliseconds: 200));

    // Open after the lines print so the output is visible first
    await Future.delayed(const Duration(milliseconds: 300));
    web.window.open(url, '_blank');
  }
}

enum TerminalLineType { command, output, error }

class TerminalLine {
  final String text;
  final TerminalLineType type;
  TerminalLine(this.text, this.type);
}
