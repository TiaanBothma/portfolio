import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/os_windows/browser/browser_window.dart';
import 'package:portfolio/os_windows/image_viewer/image_viewer_window.dart';
import 'package:portfolio/os_windows/monitor/monitor_window.dart';
import 'package:portfolio/os_windows/notepad/notepad_window.dart';
import 'package:portfolio/os_windows/settings_app/settings_window.dart';
import 'package:portfolio/os_windows/terminal/terminal_window.dart';
import 'package:portfolio/os_windows/vault/vault_window.dart';
import 'package:portfolio/widgets/drag_resize_window.dart';
import 'package:portfolio/widgets/dynamic_wallpaper.dart';
import 'package:portfolio/widgets/main_layout.dart';
import 'package:portfolio/widgets/status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: DynamicWallpaper()),
        MainLayout(
          child: Stack(
            children: [
              Obx(() {
                final settings = Get.find<SettingsController>();
                return Positioned(
                  top: 35,
                  left: 20,
                  child: Visibility(
                    visible: settings.showStatusCard.value,
                    child: const StatusCard(),
                  ),
                );
              }),
              const DraggableResizableWindow(
                windowId: 'terminal',
                minWidth: 400,
                minHeight: 250,
                child: TerminalWindow(),
              ),
              const DraggableResizableWindow(
                windowId: 'browser',
                minWidth: 600,
                minHeight: 400,
                child: BrowserWindow(),
              ),
              const DraggableResizableWindow(
                windowId: 'vault',
                minWidth: 600,
                minHeight: 400,
                child: VaultWindow(),
              ),
              const DraggableResizableWindow(
                windowId: 'notepad',
                minWidth: 400,
                minHeight: 300,
                child: NotepadWindow(),
              ),
              const DraggableResizableWindow(
                windowId: 'imageviewer',
                minWidth: 400,
                minHeight: 300,
                child: ImageViewerWindow(),
              ),
              const DraggableResizableWindow(
                windowId: 'settings',
                minWidth: 400,
                minHeight: 500,
                child: SettingsWindow(),
              ),
              const DraggableResizableWindow(
                windowId: 'monitor',
                minWidth: 500,
                minHeight: 400,
                child: MonitorWindow(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
