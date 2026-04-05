import 'package:flutter/material.dart';
import 'package:portfolio/home_page.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DeviceGuard extends StatelessWidget {
  const DeviceGuard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    if (isMobile) {
      return const _MobileBlockScreen();
    }

    return const HomePage();
  }
}

class _MobileBlockScreen extends StatelessWidget {
  const _MobileBlockScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIconsRegular.desktopTower,
                color: AppColors.blue,
                size: 64,
              ),
              const SizedBox(height: 32),
              Text(
                'Desktop Only',
                style: AppTextStyles.display.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tiaan Bothma OS is designed for desktop.',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white60,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please visit on a desktop or laptop browser.',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white60,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.blue.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'tiaanbothma.dev',
                  style: AppTextStyles.terminal.copyWith(
                    color: AppColors.blue,
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