import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_conroller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';

class TerminalWindow extends StatelessWidget {
  const TerminalWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 500,
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.blue.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('tiaan@portfolio:~\$', style: AppTextStyles.terminal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
  final controller = Get.find<DesktopController>();

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('terminal', style: AppTextStyles.label),
        GestureDetector(
          onTap: controller.toggleTerminal,
          child: const Icon(
            PhosphorIconsRegular.x,
            color: Colors.white54,
            size: 14,
          ),
        ),
      ],
    ),
  );
}
}
