import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/file_system_data.dart';
import 'package:portfolio/os_windows/terminal/terminal_commands.dart';

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
      TerminalLine('Type "help" for essential commands or "man -a" for all commands.', TerminalLineType.output),
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
  void _processCommand(String raw) {
    final command = raw.trim();

    if (command.toLowerCase() == 'clear') {
      outputLines.clear();
      return;
    }

    // cd command
    if (command.toLowerCase() == 'cd ~' || command.toLowerCase() == 'cd') {
      currentPath.clear();
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    if (command.toLowerCase() == 'cd ..') {
      if (currentPath.isNotEmpty) currentPath.removeLast();
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    if (command.toLowerCase().startsWith('cd ')) {
      final target = command.substring(3).trim();
      final match = currentFolder.subFolders.firstWhereOrNull(
        (f) => f.name.toLowerCase() == target.toLowerCase(),
      );
      if (match != null) {
        currentPath.add(match.name);
        outputLines.add(TerminalLine('', TerminalLineType.output));
      } else {
        outputLines.add(TerminalLine(
          'cd: $target: No such directory',
          TerminalLineType.error,
        ));
      }
      outputLines.add(TerminalLine('', TerminalLineType.output));
      return;
    }

    final result = TerminalCommands.process(command, this);
    outputLines.addAll(result);
    outputLines.add(TerminalLine('', TerminalLineType.output));
    _scrollToBottom();
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
        final completed = '${parts.sublist(0, parts.length - 1).join(' ')} ${matches[0]}';
        inputController.value = TextEditingValue(
          text: completed,
          selection: TextSelection.collapsed(offset: completed.length),
        );
        currentInput.value = completed;
      } else if (matches.length > 1) {
        outputLines.add(TerminalLine(
          matches.join('    '),
          TerminalLineType.output,
        ));
        _scrollToBottom();
      }
      return;
    }

    // Complete ssh
    if (firstWord == 'ssh' && parts.length >= 2) {
      final partial = parts.last.toLowerCase();
      final sshTargets = ['linkedin', 'github', 'fiverr'];
      final matches =
          sshTargets.where((t) => t.startsWith(partial)).toList();

      if (matches.length == 1) {
        final completed = 'ssh ${matches[0]}';
        inputController.value = TextEditingValue(
          text: completed,
          selection: TextSelection.collapsed(offset: completed.length),
        );
        currentInput.value = completed;
      } else if (matches.length > 1) {
        outputLines.add(
            TerminalLine(matches.join('    '), TerminalLineType.output));
        _scrollToBottom();
      }
      return;
    }

    // Complete open
    if (firstWord == 'open' && parts.length >= 2) {
      final partial = parts.last.toLowerCase();
      final openTargets = ['vault', 'browser', 'terminal'];
      final matches =
          openTargets.where((t) => t.startsWith(partial)).toList();

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
      'help', 'whoami', 'cv -view', 'projects -list', 'experience -list',
      'education -list', 'skills -list', 'certifications -list', 'contact',
      'ssh', 'open', 'ping', 'echo', 'ls', 'cd', 'cat', 'neofetch',
      'sudo apt update', 'man', 'clear',
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
      outputLines
          .add(TerminalLine(matches.join('    '), TerminalLineType.output));
      _scrollToBottom();
    }
  }

  // ─── HISTORY ──────────────────────────────────────────────
  void navigateHistory(bool up) {
    if (_commandHistory.isEmpty) return;

    if (up) {
      _historyIndex =
          (_historyIndex - 1).clamp(0, _commandHistory.length - 1);
    } else {
      _historyIndex =
          (_historyIndex + 1).clamp(0, _commandHistory.length);
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
}

enum TerminalLineType { command, output, error }

class TerminalLine {
  final String text;
  final TerminalLineType type;
  TerminalLine(this.text, this.type);
}