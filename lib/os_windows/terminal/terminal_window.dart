import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/window_state.dart';
import 'package:portfolio/os_windows/terminal/terminal_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';

class TerminalWindow extends StatelessWidget {
  const TerminalWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final terminal = Get.find<TerminalController>();

    return Container(
      width: 700,
      height: 500,
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blue.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTitleBar(),
          Expanded(child: _buildOutput(terminal)),
          _buildInputRow(terminal),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (details) => desktop.dragWindow('terminal', details.delta),
      child: Container(
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
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => desktop.toggleTerminal(),
                child: const Icon(
                  PhosphorIconsRegular.minus,
                  color: Colors.white54,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutput(TerminalController terminal) {
    return Obx(
      () => ListView.builder(
        controller: terminal.scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: terminal.outputLines.length,
        itemBuilder: (context, index) {
          final line = terminal.outputLines[index];
          return Text(
            line.text,
            style: AppTextStyles.terminal.copyWith(
              color: _lineColor(line.type),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputRow(TerminalController terminal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.blue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${terminal.prompt} ',
            style: AppTextStyles.terminal.copyWith(color: AppColors.blue),
          ),
          Expanded(
            child: TextField(
              controller: terminal.inputController,
              focusNode: terminal.focusNode,
              autofocus: true,
              style: AppTextStyles.terminal.copyWith(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: terminal.onInputChanged,
              onSubmitted: (_) {
                terminal.onSubmit();
                terminal.focusNode.requestFocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _lineColor(TerminalLineType type) {
    switch (type) {
      case TerminalLineType.command:
        return Colors.white;
      case TerminalLineType.output:
        return const Color(0xFF00FF88);
      case TerminalLineType.error:
        return Colors.redAccent;
    }
  }
}
