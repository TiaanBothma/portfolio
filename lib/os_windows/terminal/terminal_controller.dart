import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio/os_windows/terminal/terminal_commands.dart';

class TerminalController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController inputController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final outputLines = <TerminalLine>[].obs;
  final currentInput = ''.obs;
  final _commandHistory = <String>[];
  int _historyIndex = -1;

  final String prompt = "tiaan@portfolio:~\$";

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

  void _printWelcome() {
    outputLines.addAll([
      TerminalLine('Welcome to Tiaan Bothma OS', TerminalLineType.output),
      TerminalLine(
        'Type "help" to see available commands',
        TerminalLineType.output,
      ),
      TerminalLine('', TerminalLineType.output),
    ]);
  }

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

  void _processCommand(String command) {
    if (command == 'clear') {
      outputLines.clear();
      return;
    }

    outputLines.addAll(TerminalCommands.process(command));
    outputLines.add(TerminalLine('', TerminalLineType.output));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
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
