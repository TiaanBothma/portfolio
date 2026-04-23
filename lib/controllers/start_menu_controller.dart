import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/widgets/start_menu.dart';

class StartMenuController extends GetxController {
  final isOpen = false.obs;
  OverlayEntry? _overlayEntry;

  void toggle(BuildContext context) {
    if (isOpen.value) {
      close();
    } else {
      open(context);
    }
  }

  void open(BuildContext context) {
    isOpen.value = true;
    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Background tap catcher
          Positioned.fill(
            child: GestureDetector(
              onTap: close,
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          // Start menu sits above the tap catcher in the same overlay
          Positioned(
            bottom: 68,
            left: 8,
            child: Material(
              color: Colors.transparent,
              child: StartMenu(),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    isOpen.value = false;
  }

  @override
  void onClose() {
    _overlayEntry?.remove();
    super.onClose();
  }
}