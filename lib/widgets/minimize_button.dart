import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MinimizeButton extends StatefulWidget {
  final VoidCallback onTap;

  const MinimizeButton({super.key, required this.onTap});

  @override
  State<MinimizeButton> createState() => MinimizeButtonState();
}

class MinimizeButtonState extends State<MinimizeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            PhosphorIconsRegular.minus,
            color: _hovered ? Colors.white : Colors.white38,
            size: 14,
          ),
        ),
      ),
    );
  }
}