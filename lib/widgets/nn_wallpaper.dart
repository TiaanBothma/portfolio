import 'dart:math';
import 'package:flutter/material.dart';

class NeuralNetworkWallpaper extends StatefulWidget {
  const NeuralNetworkWallpaper({super.key});

  @override
  State<NeuralNetworkWallpaper> createState() => _NeuralNetworkWallpaperState();
}

class _NeuralNetworkWallpaperState extends State<NeuralNetworkWallpaper>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Node> _nodes = [];
  Offset _mousePosition = Offset.zero;
  final Random _random = Random();
  static const int _nodeCount = 60;
  static const double _connectionDistance = 150.0;
  static const double _mouseInfluenceRadius = 120.0;

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
            (_random.nextDouble() - 0.5) * 0.4,
            (_random.nextDouble() - 0.5) * 0.4,
          ),
          radius: _random.nextDouble() * 2 + 1.5,
        ),
      );
    }
  }

  void _updateNodes(Size size) {
    for (final node in _nodes) {
      node.position += node.velocity;

      // Mouse influence — nodes are gently attracted toward cursor
      final dx = _mousePosition.dx - node.position.dx;
      final dy = _mousePosition.dy - node.position.dy;
      final dist = sqrt(dx * dx + dy * dy);

      if (dist < _mouseInfluenceRadius && dist > 0) {
        final force = (1 - dist / _mouseInfluenceRadius) * 0.3;
        node.velocity += Offset(dx / dist * force, dy / dist * force);
      }

      // Dampen velocity to prevent runaway speed
      final speed = node.velocity.distance;
      if (speed > 1.2) {
        node.velocity = node.velocity / speed * 1.2;
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
    return MouseRegion(
      onHover: (event) {
        setState(() => _mousePosition = event.localPosition);
      },
      child: AnimatedBuilder(
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
                  mousePosition: _mousePosition,
                  connectionDistance: _connectionDistance,
                  mouseInfluenceRadius: _mouseInfluenceRadius,
                ),
                size: size,
              );
            },
          );
        },
      ),
    );
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
  final Offset mousePosition;
  final double connectionDistance;
  final double mouseInfluenceRadius;

  _NeuralNetworkPainter({
    required this.nodes,
    required this.mousePosition,
    required this.connectionDistance,
    required this.mouseInfluenceRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF02010A),
    );

    final linePaint = Paint()..strokeWidth = 0.5;
    final nodePaint = Paint();
    final mouseLinePaint = Paint()..strokeWidth = 0.8;

    // Draw connections between nodes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dx = nodes[i].position.dx - nodes[j].position.dx;
        final dy = nodes[i].position.dy - nodes[j].position.dy;
        final dist = sqrt(dx * dx + dy * dy);

        if (dist < connectionDistance) {
          final opacity = (1 - dist / connectionDistance) * 0.35;
          linePaint.color = Color.fromRGBO(13, 0, 164, opacity);
          canvas.drawLine(nodes[i].position, nodes[j].position, linePaint);
        }
      }

      // Draw connections from node to mouse
      final mdx = nodes[i].position.dx - mousePosition.dx;
      final mdy = nodes[i].position.dy - mousePosition.dy;
      final mouseDist = sqrt(mdx * mdx + mdy * mdy);

      if (mouseDist < mouseInfluenceRadius) {
        final opacity = (1 - mouseDist / mouseInfluenceRadius) * 0.6;
        mouseLinePaint.color = Color.fromRGBO(34, 0, 124, opacity);
        canvas.drawLine(nodes[i].position, mousePosition, mouseLinePaint);
      }
    }

    // Draw nodes
    for (final node in nodes) {
      final mdx = node.position.dx - mousePosition.dx;
      final mdy = node.position.dy - mousePosition.dy;
      final mouseDist = sqrt(mdx * mdx + mdy * mdy);
      final isNearMouse = mouseDist < mouseInfluenceRadius;

      nodePaint.color = isNearMouse
          ? const Color(0xFF0D00A4).withValues(alpha: 0.9)
          : const Color(0xFF140152).withValues(alpha: 0.7);

      canvas.drawCircle(
        node.position,
        isNearMouse ? node.radius * 1.5 : node.radius,
        nodePaint,
      );
    }

    // Draw mouse cursor dot
    canvas.drawCircle(
      mousePosition,
      4,
      Paint()..color = const Color(0xFF0D00A4).withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(_NeuralNetworkPainter old) => true;
}
