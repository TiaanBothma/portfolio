import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/data/file_system_data.dart';
import 'package:portfolio/os_windows/vault/vault_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';

class VaultWindow extends StatelessWidget {
  const VaultWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        children: [
          _buildTitleBar(),
          _buildToolBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    final desktop = Get.find<DesktopController>();

    return GestureDetector(
      onPanUpdate: (d) => desktop.dragWindow('vault', d.delta),
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
            Row(
              children: [
                Icon(PhosphorIconsRegular.vault,
                    color: Colors.white54, size: 13),
                const SizedBox(width: 8),
                Text('vault', style: AppTextStyles.label),
              ],
            ),
            MinimizeButton(onTap: () => desktop.toggleWindow('vault')),
          ],
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    final vault = Get.find<VaultController>();

    return Obx(() => Container(
      height: 36,
      color: AppColors.deepBlue.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Back button
          _toolbarButton(
            icon: PhosphorIconsRegular.arrowLeft,
            enabled: vault.canGoBack,
            onTap: vault.goBack,
          ),
          const SizedBox(width: 4),
          // Home button
          _toolbarButton(
            icon: PhosphorIconsRegular.house,
            enabled: true,
            onTap: vault.goHome,
          ),
          const SizedBox(width: 12),
          // Path bar
          Expanded(
            child: Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: AppColors.blue.withValues(alpha: 0.3)),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  vault.currentPath,
                  style: AppTextStyles.terminal.copyWith(
                      color: Colors.white60, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _toolbarButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white60 : Colors.white24,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Row(
      children: [
        _buildSidebar(),
        _buildVerticalDivider(),
        Expanded(child: _buildFilePanel()),
        _buildVerticalDivider(),
        _buildPreviewPanel(),
      ],
    );
  }

  Widget _buildSidebar() {
    final vault = Get.find<VaultController>();

    return Container(
      width: 160,
      color: AppColors.deepBlue.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Text('LOCATIONS',
                style: AppTextStyles.label
                    .copyWith(color: Colors.white24, fontSize: 10, letterSpacing: 1.5)),
          ),
          _sidebarItem(
            icon: PhosphorIconsRegular.house,
            label: 'Home',
            onTap: vault.goHome,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Text('FOLDERS',
                style: AppTextStyles.label
                    .copyWith(color: Colors.white24, fontSize: 10, letterSpacing: 1.5)),
          ),
          ...FileSystemData.root.subFolders.map((f) => _sidebarItem(
            icon: PhosphorIconsRegular.folder,
            label: f.name,
            onTap: () => vault.openFolder(f),
          )),
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _HoverItem(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 13),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  style: AppTextStyles.label
                      .copyWith(color: Colors.white70, fontSize: 12),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePanel() {
    final vault = Get.find<VaultController>();

    return Obx(() {
      final folder = vault.currentFolder.value;

      return ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (folder.subFolders.isNotEmpty) ...[
            _sectionLabel('Folders'),
            const SizedBox(height: 8),
            ...folder.subFolders.map((f) => _folderItem(f, vault)),
            const SizedBox(height: 16),
          ],
          if (folder.files.isNotEmpty) ...[
            _sectionLabel('Files'),
            const SizedBox(height: 8),
            ...folder.files.map((f) => _fileItem(f, vault)),
          ],
          if (folder.subFolders.isEmpty && folder.files.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text('Empty folder',
                    style: AppTextStyles.label.copyWith(color: Colors.white24)),
              ),
            ),
        ],
      );
    });
  }

  Widget _sectionLabel(String label) {
    return Text(label,
        style: AppTextStyles.label
            .copyWith(color: Colors.white24, fontSize: 10, letterSpacing: 1.5));
  }

  Widget _folderItem(VaultFolder folder, VaultController vault) {
    return Obx(() {
      final isSelected = vault.selectedFolder.value?.name == folder.name;

      return _HoverItem(
        onTap: () => vault.selectFolder(folder),
        onDoubleTap: () => vault.openFolder(folder),
        selected: isSelected,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(PhosphorIconsFill.folder,
                  color: const Color(0xFF6B8AFF), size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(folder.name,
                    style: AppTextStyles.label
                        .copyWith(color: Colors.white, fontSize: 13)),
              ),
              Text('${folder.files.length + folder.subFolders.length} items',
                  style: AppTextStyles.label
                      .copyWith(color: Colors.white30, fontSize: 11)),
            ],
          ),
        ),
      );
    });
  }

  Widget _fileItem(VaultFile file, VaultController vault) {
    return Obx(() {
      final isSelected = vault.selectedFile.value?.name == file.name;

      return _HoverItem(
        onTap: () => vault.selectFile(file),
        selected: isSelected,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(PhosphorIconsRegular.fileText,
                  color: Colors.white54, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(file.name,
                    style: AppTextStyles.label
                        .copyWith(color: Colors.white, fontSize: 13)),
              ),
              Text('.txt',
                  style: AppTextStyles.label
                      .copyWith(color: Colors.white30, fontSize: 11)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPreviewPanel() {
    final vault = Get.find<VaultController>();

    return Obx(() {
      final file = vault.selectedFile.value;
      final folder = vault.selectedFolder.value;

      return Container(
        width: 220,
        color: AppColors.deepBlue.withValues(alpha: 0.2),
        child: file != null
            ? _filePreview(file)
            : folder != null
                ? _folderPreview(folder)
                : _emptyPreview(),
      );
    });
  }

  Widget _filePreview(VaultFile file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.3),
            border: Border(
              bottom: BorderSide(
                  color: AppColors.blue.withValues(alpha: 0.2)),
            ),
          ),
          child: Column(
            children: [
              Icon(PhosphorIconsRegular.fileText,
                  color: AppColors.blue, size: 36),
              const SizedBox(height: 8),
              Text(
                file.name,
                style: AppTextStyles.label
                    .copyWith(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Text(
              file.content,
              style: AppTextStyles.terminal.copyWith(
                  color: Colors.white60, fontSize: 10, height: 1.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _folderPreview(VaultFolder folder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.3),
            border: Border(
              bottom: BorderSide(
                  color: AppColors.blue.withValues(alpha: 0.2)),
            ),
          ),
          child: Column(
            children: [
              Icon(PhosphorIconsFill.folder,
                  color: const Color(0xFF6B8AFF), size: 36),
              const SizedBox(height: 8),
              Text(folder.name,
                  style: AppTextStyles.label
                      .copyWith(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _previewStat('Folders', folder.subFolders.length.toString()),
              const SizedBox(height: 6),
              _previewStat('Files', folder.files.length.toString()),
              const SizedBox(height: 6),
              _previewStat('Type', 'File Folder'),
              const SizedBox(height: 16),
              Text('Double-click to open',
                  style: AppTextStyles.label
                      .copyWith(color: Colors.white24, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _previewStat(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.label
                .copyWith(color: Colors.white30, fontSize: 11)),
        Text(value,
            style: AppTextStyles.label
                .copyWith(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _emptyPreview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIconsRegular.selectionSlash,
              color: Colors.white12, size: 32),
          const SizedBox(height: 12),
          Text('No item selected',
              style: AppTextStyles.label
                  .copyWith(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      color: AppColors.blue.withValues(alpha: 0.15),
    );
  }
}

class _HoverItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final bool selected;

  const _HoverItem({
    required this.child,
    required this.onTap,
    this.onDoubleTap,
    this.selected = false,
  });

  @override
  State<_HoverItem> createState() => _HoverItemState();
}

class _HoverItemState extends State<_HoverItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.blue.withValues(alpha: 0.25)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: widget.selected
                  ? AppColors.blue.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}