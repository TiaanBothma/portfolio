import 'dart:async';
import 'package:flutter/material.dart';
import 'package:portfolio/themes/text_style.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late String _time;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _time = _currentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _time = _currentTime());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Tiaan Bothma OS', style: AppTextStyles.label),
          Text(_time, style: AppTextStyles.label),
        ],
      ),
    );
  }
}