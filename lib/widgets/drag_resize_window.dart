import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/window_state.dart';

class DraggableResizableWindow extends StatelessWidget {
  final Widget child;
  final String windowId;
  final double minWidth;
  final double minHeight;

  const DraggableResizableWindow({
    super.key,
    required this.child,
    required this.windowId,
    this.minWidth = 300,
    this.minHeight = 200,
  });

@override
Widget build(BuildContext context) {
  final controller = Get.find<DesktopController>();

  return Obx(() {
    final state = controller.getWindowRx(windowId).value;

    return Positioned(
      left: state.offset.dx,
      top: state.offset.dy,
      child: Visibility(
        visible: state.isOpen,
        child: SizedBox(
          width: state.size.width,
          height: state.size.height,
          child: Stack(
            children: [
              child,
              _buildResizeHandle(controller),
            ],
          ),
        ),
      ),
    );
  });
}

  Widget _buildResizeHandle(DesktopController controller) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onPanUpdate: (details) {
          controller.resizeWindow(windowId, details.delta, minWidth, minHeight);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeUpLeftDownRight,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Icon(
              Icons.drag_handle,
              color: Colors.white24,
              size: 10,
            ),
          ),
        ),
      ),
    );
  }
}
