import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/os_windows/image_viewer/image_viewer_controller.dart';
import 'package:portfolio/themes/colors.dart';
import 'package:portfolio/themes/text_style.dart';
import 'package:portfolio/widgets/minimize_button.dart';

class ImageViewerWindow extends StatelessWidget {
  const ImageViewerWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blue.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTitleBar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    final desktop = Get.find<DesktopController>();
    final viewer = Get.find<ImageViewerController>();

    return GestureDetector(
      onPanUpdate: (d) => desktop.dragWindow('imageviewer', d.delta),
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
              // Back to vault button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    desktop.toggleWindow('imageviewer');
                    desktop.toggleWindow('vault');
                  },
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
              Icon(PhosphorIconsRegular.image, color: Colors.white54, size: 13),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  viewer.currentImageName.value,
                  style: AppTextStyles.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              MinimizeButton(onTap: viewer.close),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final viewer = Get.find<ImageViewerController>();

    return Obx(() {
      final path = viewer.currentImagePath.value;

      if (path == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(PhosphorIconsRegular.image, color: Colors.white12, size: 48),
              const SizedBox(height: 16),
              Text(
                'No image open',
                style: AppTextStyles.body.copyWith(color: Colors.white24),
              ),
            ],
          ),
        );
      }

      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              path,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIconsRegular.imageBroken,
                    color: Colors.white24,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Image not found\n$path',
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white24,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
