import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/controllers/start_menu_controller.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/os_windows/browser/browser_controller.dart';
import 'package:portfolio/os_windows/image_viewer/image_viewer_controller.dart';
import 'package:portfolio/os_windows/notepad/notepad_controller.dart';
import 'package:portfolio/os_windows/terminal/terminal_controller.dart';
import 'package:portfolio/os_windows/vault/vault_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/widgets/device_guard.dart';

void main() {
  Get.put(DesktopController());
  Get.put(TerminalController());
  Get.put(BrowserController());
  Get.put(StartMenuController());
  Get.put(VaultController());
  Get.put(NotepadController());
  Get.put(ImageViewerController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tiaan Bothma OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        textTheme: GoogleFonts.oxaniumTextTheme(),
      ),

      home: const DeviceGuard(),
    );
  }
}
