import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/os_windows/notepad/notepad_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';

class NotepadWindow extends StatelessWidget {
  const NotepadWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
          _buildMenuBar(),
          Expanded(child: _buildContent()),
          _buildStatusBar(),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    final desktop = Get.find<DesktopController>();
    final notepad = Get.find<NotepadController>();

    return GestureDetector(
      onPanUpdate: (d) => desktop.dragWindow('notepad', d.delta),
      child: Obx(
        () => Container(
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
              // Back button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    desktop.toggleWindow('notepad');
                    desktop.toggleWindow('vault');
                  },
                  child: Icon(
                    PhosphorIconsRegular.arrowLeft,
                    color: Colors.white54,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Icon(
                PhosphorIconsRegular.notepad,
                color: Colors.white54,
                size: 13,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  notepad.currentFile.value?.name ?? 'notepad',
                  style: AppTextStyles.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              MinimizeButton(onTap: notepad.close),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      height: 28,
      color: AppColors.deepBlue.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [_menuItem('File'), _menuItem('Edit'), _menuItem('View')],
      ),
    );
  }

  Widget _menuItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final notepad = Get.find<NotepadController>();

    return Obx(() {
      final file = notepad.currentFile.value;

      if (file == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIconsRegular.notepad,
                color: Colors.white12,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'No file open',
                style: AppTextStyles.body.copyWith(color: Colors.white24),
              ),
              const SizedBox(height: 8),
              Text(
                'Open a file from Vault to view it here',
                style: AppTextStyles.label.copyWith(color: Colors.white24),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildFormattedContent(file.content),
      );
    });
  }

  Widget _buildFormattedContent(String content) {
    final lines = content.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _buildLine(line)).toList(),
    );
  }

  Widget _buildLine(String line) {
    // Separator lines
    if (line.startsWith('=')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColors.blue.withValues(alpha: 0.4),
        ),
      );
    }

    // Section headers (ALL CAPS lines like "RESPONSIBILITIES:")
    final isHeader =
        line == line.toUpperCase() &&
        line.trim().isNotEmpty &&
        line.trim().length > 2 &&
        !line.trim().startsWith('-') &&
        !line.trim().startsWith('+') &&
        !line.trim().startsWith('~') &&
        !line.trim().startsWith('!');

    // Key -> Value lines
    final isKeyValue = RegExp(r'^[A-Z_]+:\s').hasMatch(line.trim());

    // Changelog markers
    if (line.trim().startsWith('+')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          line,
          style: AppTextStyles.terminal.copyWith(
            color: const Color(0xFF00FF88),
            fontSize: 12,
            height: 1.6,
          ),
        ),
      );
    }

    if (line.trim().startsWith('~')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          line,
          style: AppTextStyles.terminal.copyWith(
            color: Colors.orangeAccent,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      );
    }

    if (line.trim().startsWith('!')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          line,
          style: AppTextStyles.terminal.copyWith(
            color: Colors.redAccent,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      );
    }

    if (isKeyValue) {
      final colonIndex = line.indexOf(':');
      final key = line.substring(0, colonIndex);
      final value = line.substring(colonIndex + 1);

      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$key:',
                style: AppTextStyles.terminal.copyWith(
                  color: AppColors.blue.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.6,
                ),
              ),
              TextSpan(
                text: value,
                style: AppTextStyles.terminal.copyWith(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isHeader) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          line,
          style: AppTextStyles.terminal.copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            height: 1.6,
          ),
        ),
      );
    }

    // Default line
    return Text(
      line.isEmpty ? ' ' : line,
      style: AppTextStyles.terminal.copyWith(
        color: Colors.white70,
        fontSize: 12,
        height: 1.6,
      ),
    );
  }

  Widget _buildStatusBar() {
    final notepad = Get.find<NotepadController>();

    return Obx(() {
      final file = notepad.currentFile.value;
      final lines = file?.content.split('\n').length ?? 0;
      final chars = file?.content.length ?? 0;

      return Container(
        height: 24,
        color: AppColors.deepBlue.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              file != null ? 'Lines: $lines    Chars: $chars' : '',
              style: AppTextStyles.label.copyWith(
                color: Colors.white30,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    });
  }
}
