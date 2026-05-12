import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';

class DraggableResizableWindow extends StatefulWidget {
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
  State<DraggableResizableWindow> createState() =>
      _DraggableResizableWindowState();
}

class _DraggableResizableWindowState extends State<DraggableResizableWindow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _wasOpen = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scaleAnim = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _updateAnimationDuration() {
    final settings = Get.find<SettingsController>();
    _animController.duration = settings.windowAnimDuration;
  }

  void _handleVisibilityChange(bool isOpen) {
    _updateAnimationDuration();

    if (isOpen && !_wasOpen) {
      _animController.forward(from: 0.0);
    } else if (!isOpen && _wasOpen) {
      _animController.reverse(from: 1.0);
    }
    _wasOpen = isOpen;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DesktopController>();

    return Obx(() {
      final state = controller.getWindowRx(widget.windowId).value;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleVisibilityChange(state.isOpen);
      });

      return Positioned(
        left: state.offset.dx,
        top: state.offset.dy,
        child: Visibility(
          visible: state.isOpen || _animController.isAnimating,
          child: SizedBox(
            width: state.size.width,
            height: state.size.height,
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    alignment: Alignment.center,
                    child: child,
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.child,
                  ),
                  _buildResizeHandle(controller),
                ],
              ),
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
          controller.resizeWindow(
            widget.windowId,
            details.delta,
            widget.minWidth,
            widget.minHeight,
          );
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
