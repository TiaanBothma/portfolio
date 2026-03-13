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
  }

  void _registerWindow(String id, WindowState state) {
    _windows[id] = state.obs;
  }

  WindowState getWindow(String id) => _windows[id]!.value;

  void toggleWindow(String id) {
    final window = _windows[id]!;
    window.value = window.value.copyWith(isOpen: !window.value.isOpen);
  }

  void dragWindow(String id, Offset delta) {
    final window = _windows[id]!;
    final current = window.value;
    window.value = current.copyWith(
      offset: Offset(
        current.offset.dx + delta.dx,
        current.offset.dy + delta.dy,
      ),
    );
  }

  void resizeWindow(
    String id,
    Offset delta,
    double minWidth,
    double minHeight,
  ) {
    final window = _windows[id]!;
    final current = window.value;
    window.value = current.copyWith(
      size: Size(
        (current.size.width + delta.dx).clamp(minWidth, double.infinity),
        (current.size.height + delta.dy).clamp(minHeight, double.infinity),
      ),
    );
  }

  void toggleTerminal() => toggleWindow('terminal');
  bool get terminalOpen => getWindow('terminal').isOpen;
}
