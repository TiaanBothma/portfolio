import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/os_windows/terminal/terminal_controller.dart';

class WindowState {
  Offset offset;
  Size size;
  bool isOpen;

  WindowState({required this.offset, required this.size, this.isOpen = false});

  WindowState copyWith({Offset? offset, Size? size, bool? isOpen}) {
    return WindowState(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}

class DesktopController extends GetxController {
  final _windows = <String, Rx<WindowState>>{};

  @override
  void onInit() {
    super.onInit();
    _registerWindow(
      'terminal',
      WindowState(offset: Offset(350, 200), size: const Size(700, 500)),
    );
    _registerWindow(
      'browser',
      WindowState(offset: const Offset(10, 10), size: Size(1250, 680)),
    );
    _registerWindow(
      'vault',
      WindowState(offset: const Offset(120, 80), size: const Size(850, 550)),
    );
    _registerWindow(
      'notepad',
      WindowState(offset: const Offset(200, 120), size: const Size(600, 500)),
    );
    _registerWindow(
      'imageviewer',
      WindowState(offset: const Offset(150, 80), size: const Size(750, 550)),
    );
    _registerWindow(
      'settings',
      WindowState(offset: const Offset(200, 100), size: const Size(500, 620)),
    );
    _registerWindow(
      'monitor',
      WindowState(offset: const Offset(180, 80), size: const Size(580, 560)),
    );
    _registerWindow(
      'casestudy',
      WindowState(offset: const Offset(120, 80), size: const Size(860, 580)),
    );
    _registerWindow(
      'env',
      WindowState(offset: const Offset(300, 150), size: const Size(480, 420)),
    );
    _registerWindow(
      'timeline',
      WindowState(offset: const Offset(80, 80), size: const Size(920, 520)),
    );
  }

  Rx<WindowState> getWindowRx(String id) => _windows[id]!;

  void _registerWindow(String id, WindowState state) {
    _windows[id] = state.obs;
  }

  WindowState getWindow(String id) => _windows[id]!.value;

  void toggleWindow(String id) {
    final isCurrentlyOpen = _windows[id]!.value.isOpen;

    for (final key in _windows.keys) {
      _windows[key]!.value = WindowState(
        offset: _windows[key]!.value.offset,
        size: _windows[key]!.value.size,
        isOpen: false,
      );
    }

    if (!isCurrentlyOpen) {
      _windows[id]!.value = WindowState(
        offset: _windows[id]!.value.offset,
        size: _windows[id]!.value.size,
        isOpen: true,
      );
      _onWindowOpened(id);
    }
  }

  void _onWindowOpened(String id) {
    if (id == 'terminal') {
      Future.delayed(const Duration(milliseconds: 150), () {
        Get.find<TerminalController>().scrollToBottom();
      });
    }
  }

  void dragWindow(String id, Offset delta) {
    final current = _windows[id]!.value;
    _windows[id]!.value = WindowState(
      offset: Offset(
        current.offset.dx + delta.dx,
        current.offset.dy + delta.dy,
      ),
      size: current.size,
      isOpen: current.isOpen,
    );
  }

  void resizeWindow(
    String id,
    Offset delta,
    double minWidth,
    double minHeight,
  ) {
    final current = _windows[id]!.value;
    _windows[id]!.value = WindowState(
      offset: current.offset,
      size: Size(
        (current.size.width + delta.dx).clamp(minWidth, double.infinity),
        (current.size.height + delta.dy).clamp(minHeight, double.infinity),
      ),
      isOpen: current.isOpen,
    );
  }

  void toggleTerminal() => toggleWindow('terminal');
  bool get terminalOpen => getWindowRx('terminal').value.isOpen;
}
