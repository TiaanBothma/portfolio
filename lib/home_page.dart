import 'package:flutter/material.dart';
import 'package:portfolio/os_windows/browser/browser_window.dart';
import 'package:portfolio/os_windows/terminal/terminal_window.dart';
import 'package:portfolio/os_windows/vault/vault_window.dart';
import 'package:portfolio/widgets/drag_resize_window.dart';
import 'package:portfolio/widgets/main_layout.dart';
import 'package:portfolio/widgets/status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/wallpaper.png', fit: BoxFit.cover),
        ),
        MainLayout(
          child: Stack(
            children: [
              const Positioned(top: 35, left: 20, child: StatusCard()),
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
            ],
          ),
        ),
      ],
    );
  }
}
