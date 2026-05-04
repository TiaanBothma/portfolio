import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/os_windows/terminal/terminal_controller.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';

class TerminalWindow extends StatelessWidget {
  const TerminalWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final terminal = Get.find<TerminalController>();
    final settings = Get.find<SettingsController>();

    return Obx(
      () => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: settings.black.withValues(
            alpha: Get.find<SettingsController>().windowTransparency.value,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: settings.accentColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            _buildTitleBar(settings),
            Expanded(child: _buildOutput(terminal)),
            _buildInputRow(terminal, settings),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar(SettingsController settings) {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (details) => desktop.dragWindow('terminal', details.delta),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: settings.deepBlue.withValues(alpha: 0.9),
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
            MinimizeButton(onTap: () => desktop.toggleWindow('terminal')),
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

  Widget _buildInputRow(TerminalController terminal, SettingsController settings) {
    final settings = Get.find<SettingsController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: settings.accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            Text(
              '${terminal.prompt} ',
              style: AppTextStyles.terminal.copyWith(
                color: settings.accentColor,
              ),
            ),
            Expanded(
              child: TextField(
                controller: terminal.inputController,
                focusNode: terminal.focusNode,
                autofocus: true,
                style: AppTextStyles.terminal.copyWith(color: Colors.white),
                cursorColor: settings.accentColor,
                cursorWidth: settings.cursorStyle.value == 'block' ? 10.0 : 2.0,
                cursorHeight: settings.cursorStyle.value == 'underline'
                    ? 2.0
                    : null,
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
