import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';

class ImageViewerController extends GetxController {
  final currentImagePath = Rx<String?>(null);
  final currentImageName = ''.obs;

  void openImage(String name, String imagePath) {
    currentImageName.value = name;
    currentImagePath.value = imagePath;
    Get.find<DesktopController>().toggleWindow('imageviewer');
  }

  void close() {
    Get.find<DesktopController>().toggleWindow('imageviewer');
    currentImagePath.value = null;
    currentImageName.value = '';
  }
}