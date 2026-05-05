import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/settings_controller.dart';

class NeuralNetworkWallpaper extends StatefulWidget {
  const NeuralNetworkWallpaper({super.key});

  @override
  State<NeuralNetworkWallpaper> createState() => _NeuralNetworkWallpaperState();
}

class _NeuralNetworkWallpaperState extends State<NeuralNetworkWallpaper>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Node> _nodes = [];
  final Random _random = Random();
  static const int _nodeCount = 60;
  static const double _connectionDistance = 180.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  void _initNodes(Size size) {
    if (_nodes.isNotEmpty) return;
    for (int i = 0; i < _nodeCount; i++) {
      _nodes.add(
        _Node(
          position: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 0.5,
            (_random.nextDouble() - 0.5) * 0.5,
          ),
          radius: _random.nextDouble() * 2 + 2,
        ),
      );
    }
  }

  void _updateNodes(Size size) {
    for (final node in _nodes) {
      node.position += node.velocity;

      // Dampen velocity
      final speed = node.velocity.distance;
      if (speed > 1.0) {
        node.velocity = node.velocity / speed * 1.0;
      }

      // Bounce off edges
      if (node.position.dx < 0 || node.position.dx > size.width) {
        node.velocity = Offset(-node.velocity.dx, node.velocity.dy);
        node.position = Offset(
          node.position.dx.clamp(0, size.width),
          node.position.dy,
        );
      }
      if (node.position.dy < 0 || node.position.dy > size.height) {
        node.velocity = Offset(node.velocity.dx, -node.velocity.dy);
        node.position = Offset(
          node.position.dx,
          node.position.dy.clamp(0, size.height),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No MouseRegion — mouse reaction removed
    return Obx(() {
      // Watches accentColor so painter rebuilds when palette changes
      final accent = Get.find<SettingsController>().accentColor;

      return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              _initNodes(size);
              _updateNodes(size);
              return CustomPaint(
                painter: _NeuralNetworkPainter(
                  nodes: _nodes,
                  connectionDistance: _connectionDistance,
                  accentColor: accent,
                ),
                size: size,
              );
            },
          );
        },
      );
    });
  }
}

class _Node {
  Offset position;
  Offset velocity;
  final double radius;

  _Node({required this.position, required this.velocity, required this.radius});
}

class _NeuralNetworkPainter extends CustomPainter {
  final List<_Node> nodes;
  final double connectionDistance;
  final Color accentColor;

  _NeuralNetworkPainter({
    required this.nodes,
    required this.connectionDistance,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF02010A),
    );

    final linePaint = Paint()..strokeWidth = 1.2;
    final nodePaint = Paint();

    // Draw connections
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dx = nodes[i].position.dx - nodes[j].position.dx;
        final dy = nodes[i].position.dy - nodes[j].position.dy;
        final dist = sqrt(dx * dx + dy * dy);

        if (dist < connectionDistance) {
          final opacity = (1 - dist / connectionDistance) * 0.55;
          linePaint.color = accentColor.withValues(alpha: opacity);
          canvas.drawLine(nodes[i].position, nodes[j].position, linePaint);
        }
      }
    }

    // Draw nodes
    for (final node in nodes) {
      nodePaint.color = accentColor.withValues(alpha: 0.75);
      canvas.drawCircle(node.position, node.radius, nodePaint);

      // Soft glow around each node
      nodePaint.color = accentColor.withValues(alpha: 0.15);
      canvas.drawCircle(node.position, node.radius * 3, nodePaint);
    }
  }

  @override
  bool shouldRepaint(_NeuralNetworkPainter old) =>
      old.accentColor != accentColor;
}
