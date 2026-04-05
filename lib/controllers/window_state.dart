import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      WindowState(offset: Offset(200, 200), size: const Size(700, 500)),
    );
    _registerWindow(
      'browser',
      WindowState(offset: const Offset(50, 50), size: const Size(1000, 800)),
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
      final current = _windows[key]!.value;
      _windows[key]!.value = WindowState(
        offset: current.offset,
        size: current.size,
        isOpen: false,
      );
    }

    if (!isCurrentlyOpen) {
      final current = _windows[id]!.value;
      _windows[id]!.value = WindowState(
        offset: current.offset,
        size: current.size,
        isOpen: true,
      );
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
