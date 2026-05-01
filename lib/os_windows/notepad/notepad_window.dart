import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/os_windows/notepad/notepad_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';
import 'package:web/web.dart' as web;

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
          _buildMenuBar(context),
          _buildFindBar(),
          Expanded(child: _buildContent()),
          _buildStatusBar(),
        ],
      ),
    );
  }

  // ─── TITLE BAR ──────────────────────────────────────────────
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
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: notepad.backToVault,
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIconsRegular.arrowLeft,
                        color: Colors.white54,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'vault',
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
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

  // ─── MENU BAR ───────────────────────────────────────────────
  Widget _buildMenuBar(BuildContext context) {
    return Obx(() {
      final notepad = Get.find<NotepadController>();

      return Container(
        height: 28,
        color: AppColors.deepBlue.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _menuTrigger(context, 'File', notepad),
            _menuTrigger(context, 'Edit', notepad),
            _menuTrigger(context, 'View', notepad),
          ],
        ),
      );
    });
  }

  Widget _menuTrigger(
    BuildContext context,
    String label,
    NotepadController notepad,
  ) {
    final isActive = notepad.activeMenu.value == label;

    return GestureDetector(
      onTap: () {
        if (notepad.activeMenu.value == label) {
          notepad.closeMenu();
        } else {
          notepad.closeMenu();
          notepad.toggleMenu(label);
          _showMenuOverlay(context, label, notepad);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.blue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showMenuOverlay(
    BuildContext context,
    String menu,
    NotepadController notepad,
  ) {
    OverlayEntry? entry;

    final items = _menuItems(menu, notepad, () => entry?.remove());

    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Background tap catcher
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                notepad.closeMenu();
                entry?.remove();
              },
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          // Menu popup — positioned below menu bar
          Positioned(
            top: _menuTopOffset(context, menu),
            left: _menuLeftOffset(context, menu),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.deepBlue.withValues(alpha: 0.97),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.blue.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: items),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(entry);
  }

  double _menuTopOffset(BuildContext context, String menu) {
    // title bar 32 + menu bar 28 = 60px from top of window
    final box = context.findRenderObject() as RenderBox?;
    final offset = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    return offset.dy + 60;
  }

  double _menuLeftOffset(BuildContext context, String menu) {
    final box = context.findRenderObject() as RenderBox?;
    final offset = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    final base = offset.dx + 12;
    switch (menu) {
      case 'File':
        return base;
      case 'Edit':
        return base + 80;
      case 'View':
        return base + 160;
      default:
        return base;
    }
  }

  List<Widget> _menuItems(
    String menu,
    NotepadController notepad,
    VoidCallback dismiss,
  ) {
    switch (menu) {
      case 'File':
        return [
          _menuItem(
            icon: PhosphorIconsRegular.arrowLeft,
            label: 'Back to Vault',
            onTap: () {
              dismiss();
              notepad.backToVault();
            },
          ),
          _menuDivider(),
          _menuItem(
            icon: PhosphorIconsRegular.printer,
            label: 'Print',
            onTap: () {
              dismiss();
              web.window.print();
            },
          ),
          _menuDivider(),
          _menuItem(
            icon: PhosphorIconsRegular.x,
            label: 'Close',
            onTap: () {
              dismiss();
              notepad.close();
            },
          ),
        ];

      case 'Edit':
        return [
          _menuItem(
            icon: PhosphorIconsRegular.magnifyingGlass,
            label: 'Find',

            onTap: () {
              dismiss();
              notepad.toggleFind();
            },
          ),
          _menuDivider(),
          _menuItem(
            icon: PhosphorIconsRegular.copy,
            label: 'Copy All',

            onTap: () {
              dismiss();
              notepad.copyAll();
            },
          ),
        ];

      case 'View':
        return [
          _menuItem(
            icon: PhosphorIconsRegular.textAa,
            label: 'Font Size +',
            onTap: () => notepad.increaseFontSize(),
          ),
          _menuItem(
            icon: PhosphorIconsRegular.textAa,
            label: 'Font Size -',
            onTap: () => notepad.decreaseFontSize(),
          ),
          _menuDivider(),
          Obx(
            () => _menuItem(
              icon: notepad.wordWrap.value
                  ? PhosphorIconsRegular.checkSquare
                  : PhosphorIconsRegular.square,
              label: 'Word Wrap',
              onTap: () => notepad.toggleWordWrap(),
            ),
          ),
          Obx(
            () => _menuItem(
              icon: notepad.showLineNumbers.value
                  ? PhosphorIconsRegular.checkSquare
                  : PhosphorIconsRegular.square,
              label: 'Line Numbers',
              onTap: () => notepad.toggleLineNumbers(),
            ),
          ),
        ];

      default:
        return [];
    }
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _NotepadMenuItem(icon: icon, label: label, onTap: onTap);
  }

  Widget _menuDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.blue.withValues(alpha: 0.2),
    );
  }

  // ─── FIND BAR ───────────────────────────────────────────────
  Widget _buildFindBar() {
    final notepad = Get.find<NotepadController>();

    return Obx(() {
      if (!notepad.showFind.value) return const SizedBox.shrink();

      return Container(
        height: 36,
        color: AppColors.deepBlue.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            const Icon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.white38,
              size: 14,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: notepad.findController,
                autofocus: true,
                style: AppTextStyles.terminal.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Find...',
                  hintStyle: AppTextStyles.terminal.copyWith(
                    color: Colors.white24,
                    fontSize: 12,
                  ),
                ),
                onChanged: (val) => notepad.findQuery.value = val,
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: notepad.toggleFind,
                child: const Icon(
                  PhosphorIconsRegular.x,
                  color: Colors.white38,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── CONTENT ────────────────────────────────────────────────
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line numbers
            if (notepad.showLineNumbers.value)
              _buildLineNumbers(file.content, notepad),
            // Content
            Expanded(child: _buildFormattedContent(file.content, notepad)),
          ],
        ),
      );
    });
  }

  Widget _buildLineNumbers(String content, NotepadController notepad) {
    final lines = content.split('\n');

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          lines.length,
          (i) => Text(
            '${i + 1}',
            style: AppTextStyles.terminal.copyWith(
              color: Colors.white24,
              fontSize: notepad.fontSize.value,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormattedContent(String content, NotepadController notepad) {
    final lines = content.split('\n');
    final query = notepad.findQuery.value.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _buildLine(line, notepad, query)).toList(),
    );
  }

  Widget _buildLine(String line, NotepadController notepad, String query) {
    final fontSize = notepad.fontSize.value;
    final wordWrap = notepad.wordWrap.value;

    // URL detection
    final urlRegex = RegExp(
      r'(https?://[^\s]+|(?:www\.)?[\w\-]+\.(?:com|app|dev|co\.za|org|net|io)/[^\s]*)',
    );
    final urlMatch = urlRegex.firstMatch(line);

    if (urlMatch != null) {
      final rawUrl = urlMatch.group(0)!;
      final url = rawUrl.startsWith('http') ? rawUrl : 'https://$rawUrl';
      final beforeUrl = line.substring(0, urlMatch.start);
      final afterUrl = line.substring(urlMatch.end);

      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: RichText(
          softWrap: wordWrap,
          text: TextSpan(
            children: [
              if (beforeUrl.isNotEmpty)
                TextSpan(
                  text: beforeUrl,
                  style: AppTextStyles.terminal.copyWith(
                    color: AppColors.blue.withValues(alpha: 0.9),
                    fontSize: fontSize,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              WidgetSpan(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => web.window.open(url, '_blank'),
                    child: Text(
                      rawUrl,
                      style: AppTextStyles.terminal.copyWith(
                        color: const Color(0xFF58A6FF),
                        fontSize: fontSize,
                        height: 1.6,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF58A6FF),
                      ),
                    ),
                  ),
                ),
              ),
              if (afterUrl.isNotEmpty)
                TextSpan(
                  text: afterUrl,
                  style: AppTextStyles.terminal.copyWith(
                    color: Colors.white70,
                    fontSize: fontSize,
                    height: 1.6,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Separator lines
    if (line.trim().startsWith('=')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColors.blue.withValues(alpha: 0.4),
        ),
      );
    }

    // Changelog markers
    if (line.trim().startsWith('+')) {
      return _simpleLine(
        line,
        const Color(0xFF00FF88),
        fontSize,
        wordWrap,
        query,
      );
    }
    if (line.trim().startsWith('~')) {
      return _simpleLine(line, Colors.orangeAccent, fontSize, wordWrap, query);
    }
    if (line.trim().startsWith('!')) {
      return _simpleLine(line, Colors.redAccent, fontSize, wordWrap, query);
    }

    // Key: Value lines
    final isKeyValue = RegExp(r'^[A-Z_]+:\s').hasMatch(line.trim());
    if (isKeyValue) {
      final colonIndex = line.indexOf(':');
      final key = line.substring(0, colonIndex);
      final value = line.substring(colonIndex + 1);

      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: RichText(
          softWrap: wordWrap,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$key:',
                style: AppTextStyles.terminal.copyWith(
                  color: AppColors.blue.withValues(alpha: 0.9),
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  height: 1.6,
                ),
              ),
              TextSpan(
                text: _highlight(value, query),
                style: AppTextStyles.terminal.copyWith(
                  color: Colors.white70,
                  fontSize: fontSize,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ALL CAPS headers
    final isHeader =
        line == line.toUpperCase() &&
        line.trim().isNotEmpty &&
        line.trim().length > 2 &&
        !line.trim().startsWith('-') &&
        !line.trim().startsWith('+');

    if (isHeader) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          line,
          softWrap: wordWrap,
          style: AppTextStyles.terminal.copyWith(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            height: 1.6,
          ),
        ),
      );
    }

    // Default
    return _simpleLine(line, Colors.white70, fontSize, wordWrap, query);
  }

  Widget _simpleLine(
    String line,
    Color color,
    double fontSize,
    bool wordWrap,
    String query,
  ) {
    final highlighted = _highlight(line, query);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        highlighted.isEmpty ? ' ' : highlighted,
        softWrap: wordWrap,
        style: AppTextStyles.terminal.copyWith(
          color: color,
          fontSize: fontSize,
          height: 1.6,
          backgroundColor:
              query.isNotEmpty && line.toLowerCase().contains(query)
              ? Colors.yellow.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
    );
  }

  String _highlight(String text, String query) {
    return text;
  }

  // ─── STATUS BAR ─────────────────────────────────────────────
  Widget _buildStatusBar() {
    final notepad = Get.find<NotepadController>();

    return Obx(() {
      final file = notepad.currentFile.value;
      final lines = file?.content.split('\n').length ?? 0;
      final chars = file?.content.length ?? 0;
      final fontSize = notepad.fontSize.value.toInt();

      return Container(
        height: 24,
        color: AppColors.deepBlue.withValues(alpha: 0.4),
        padding: const EdgeInsets.only(left: 12, right: 24),
        child: Row(
          children: [
            // Word wrap indicator
            Text(
              notepad.wordWrap.value ? 'Wrap: On' : 'Wrap: Off',
              style: AppTextStyles.label.copyWith(
                color: Colors.white30,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 16),
            // Font size indicator
            Text(
              'Size: $fontSize',
              style: AppTextStyles.label.copyWith(
                color: Colors.white30,
                fontSize: 10,
              ),
            ),
            const Spacer(),
            // Lines and chars
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

// ─── MENU ITEM WIDGET ─────────────────────────────────────────
class _NotepadMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NotepadMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_NotepadMenuItem> createState() => _NotepadMenuItemState();
}

class _NotepadMenuItemState extends State<_NotepadMenuItem> {
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
          duration: const Duration(milliseconds: 100),
          color: _hovered
              ? AppColors.blue.withValues(alpha: 0.2)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: _hovered ? Colors.white : Colors.white54,
                size: 14,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTextStyles.label.copyWith(
                    color: _hovered ? Colors.white : Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
