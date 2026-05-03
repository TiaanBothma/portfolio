import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/settings_controller.dart';
import 'package:portfolio/widgets/nn_wallpaper.dart';

class DynamicWallpaper extends StatelessWidget {
  const DynamicWallpaper({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(() {
      switch (settings.wallpaper.value) {
        case 'neural':
          return const NeuralNetworkWallpaper();
        case 'wallpaper2':
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF020111), Color(0xFF0D0221)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          );
        case 'wallpaper3':
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF04052E), Color(0xFF140152)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          );
        default:
          return Image.asset(
            'assets/wallpaper.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
      }
    });
  }
}
