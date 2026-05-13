import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/data/file_system_data.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/os_windows/terminal/terminal_commands.dart';
import 'package:portfolio/os_windows/vault/vault_controller.dart';
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

    // Wait for settings to finish loading before printing welcome
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settings = Get.find<SettingsController>();
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return !settings.loaded.value;
      });
      _printWelcome();
    });
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
    final settings = Get.find<SettingsController>();

    switch (settings.terminalWelcome.value) {
      case 'none':
        return;
      case 'neofetch':
        outputLines.addAll(_neofetchLines());
        outputLines.add(TerminalLine('', TerminalLineType.output));
        return;
      default:
        outputLines.addAll([
          TerminalLine('Welcome to Tiaan Bothma OS', TerminalLineType.output),
          TerminalLine(
            'Type "help" for essential commands or "man -a" for all commands.',
            TerminalLineType.output,
          ),
          TerminalLine('', TerminalLineType.output),
        ]);
    }
  }

  List<TerminalLine> _neofetchLines() {
    return TerminalCommands.neofetchLines();
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
    scrollToBottom();
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

    if (lower.startsWith('sudo apt-get install ') ||
        lower.startsWith('apt-get install ') ||
        lower.startsWith('apt install ')) {
      final package = lower
          .replaceFirst('sudo apt-get install ', '')
          .replaceFirst('apt-get install ', '')
          .replaceFirst('apt install ', '')
          .trim();

      await _aptInstall(package);
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
    scrollToBottom();
  }

  Future<void> addLinesWithDelay(
    List<TerminalLine> lines, {
    Duration delay = const Duration(milliseconds: 80),
  }) async {
    for (final line in lines) {
      await Future.delayed(delay);
      outputLines.add(line);
      scrollToBottom();
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
        scrollToBottom();
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
        scrollToBottom();
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
      scrollToBottom();
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
  void scrollToBottom() {
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
      'cv': '/cv.pdf',
    };

    final url = urls[target];
    if (url == null) {
      outputLines.add(
        TerminalLine('ssh: $target: Host not found', TerminalLineType.error),
      );
      outputLines.add(
        TerminalLine(
          'Available: ssh linkedin | ssh github | ssh fiverr | ssh cv',
          TerminalLineType.output,
        ),
      );
      return;
    }

    if (target == 'cv') {
      await addLinesWithDelay([
        TerminalLine('Locating cv.pdf...', TerminalLineType.output),
      ], delay: const Duration(milliseconds: 300));

      await Future.delayed(const Duration(milliseconds: 400));

      await addLinesWithDelay([
        TerminalLine('Found: /cv.pdf', TerminalLineType.output),
        TerminalLine('Opening in new tab...', TerminalLineType.output),
      ], delay: const Duration(milliseconds: 200));

      await Future.delayed(const Duration(milliseconds: 200));
      web.window.open('/cv.pdf', '_blank');
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

    await Future.delayed(const Duration(milliseconds: 300));
    web.window.open(url, '_blank');
  }

  Future<void> _aptInstall(String package) async {
    final desktop = Get.find<DesktopController>();

    final packageMap = {
      'terminal': {'window': 'terminal', 'folder': null},
      'browser': {'window': 'browser', 'folder': null},
      'vault': {'window': 'vault', 'folder': null},
      'files': {'window': 'vault', 'folder': null},
      'notepad': {'window': 'notepad', 'folder': null},
      'settings': {'window': 'settings', 'folder': null},
      'imageviewer': {'window': 'imageviewer', 'folder': null},
      'image-viewer': {'window': 'imageviewer', 'folder': null},
      'cv': {'window': null, 'folder': null},
      'experience': {'window': 'vault', 'folder': 'Experience'},
      'projects': {'window': 'vault', 'folder': 'Projects'},
      'education': {'window': 'vault', 'folder': 'Education'},
      'certifications': {'window': 'vault', 'folder': 'Certifications'},
    };

    // Special readable names for output
    final displayNames = {
      'terminal': 'terminal',
      'browser': 'browser',
      'vault': 'vault',
      'files': 'vault',
      'notepad': 'notepad',
      'settings': 'settings',
      'imageviewer': 'image-viewer',
      'image-viewer': 'image-viewer',
      'image_viewer': 'image-viewer',
      'cv': 'cv.pdf',
      'experience': 'vault (Experience)',
      'projects': 'vault (Projects)',
      'education': 'vault (Education)',
      'certifications': 'vault (Certifications)',
    };

    if (!packageMap.containsKey(package)) {
      await addLinesWithDelay([
        TerminalLine('Reading package lists... Done', TerminalLineType.output),
        TerminalLine(
          'Building dependency tree... Done',
          TerminalLineType.output,
        ),
        TerminalLine('', TerminalLineType.output),
        TerminalLine(
          'E: Unable to locate package $package',
          TerminalLineType.error,
        ),
        TerminalLine(
          'Available: terminal, browser, vault, notepad, settings, cv, experience, projects, education, certifications',
          TerminalLineType.output,
        ),
      ], delay: const Duration(milliseconds: 120));
      return;
    }

    final displayName = displayNames[package] ?? package;

    await addLinesWithDelay([
      TerminalLine('Reading package lists... Done', TerminalLineType.output),
      TerminalLine('Building dependency tree... Done', TerminalLineType.output),
      TerminalLine(
        'Reading state information... Done',
        TerminalLineType.output,
      ),
      TerminalLine('', TerminalLineType.output),
      TerminalLine(
        'The following NEW packages will be installed:',
        TerminalLineType.output,
      ),
      TerminalLine('  $displayName', TerminalLineType.output),
      TerminalLine('', TerminalLineType.output),
      TerminalLine(
        '0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.',
        TerminalLineType.output,
      ),
    ], delay: const Duration(milliseconds: 100));

    await Future.delayed(const Duration(milliseconds: 200));

    // Progress bar animation
    for (int i = 1; i <= 10; i++) {
      final filled = '█' * i;
      final empty = '░' * (10 - i);
      final percent = i * 10;
      outputLines.add(
        TerminalLine(
          'Installing: [$filled$empty] $percent%',
          TerminalLineType.output,
        ),
      );
      // Remove previous progress line and replace
      if (outputLines.length > 1) {
        final last = outputLines.removeLast();
        if (outputLines.isNotEmpty) outputLines.removeLast();
        outputLines.add(last);
      }
      await Future.delayed(const Duration(milliseconds: 120));
    }

    await addLinesWithDelay([
      TerminalLine('', TerminalLineType.output),
      TerminalLine('Setting up $displayName... Done', TerminalLineType.output),
      TerminalLine('Launching $displayName...', TerminalLineType.output),
    ], delay: const Duration(milliseconds: 150));

    await Future.delayed(const Duration(milliseconds: 400));

    if (package == 'cv') {
      web.window.open('/cv.pdf', '_blank');
    } else {
      final entry = packageMap[package];
      if (entry != null) {
        final windowId = entry['window'];
        final folder = entry['folder'];

        if (windowId != null) {
          desktop.toggleWindow(windowId);

          // Navigate to specific folder if specified
          if (folder != null) {
            await Future.delayed(const Duration(milliseconds: 200));
            Get.find<VaultController>().navigateToFolder(folder);
          }
        }
      }
    }
  }
}

enum TerminalLineType { command, output, error }

class TerminalLine {
  final String text;
  final TerminalLineType type;
  TerminalLine(this.text, this.type);
}
