import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/controllers/window_state.dart';
import 'package:portfolio/home_page.dart';
import 'package:portfolio/os_windows/browser/browser_controller.dart';
import 'package:portfolio/os_windows/terminal/terminal_controller.dart';
import 'package:portfolio/themes/colors.dart';

void main() {
  Get.put(DesktopController());
  Get.put(TerminalController());
  Get.put(BrowserController());
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
      home: HomePage(),
    );
  }
}
