import 'package:flutter/material.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';

class TerminalWindow extends StatelessWidget {
  const TerminalWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        children: [
          _buildTitleBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'tiaan@portfolio:~\$',
                style: AppTextStyles.terminal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text('terminal', style: AppTextStyles.label),
        ],
      ),
    );
  }
}