import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/data/file_system_data.dart';

class NotepadController extends GetxController {
  final currentFile = Rx<VaultFile?>(null);

  void openFile(VaultFile file) {
    currentFile.value = file;
    Get.find<DesktopController>().toggleWindow('notepad');
  }

  void close() {
    Get.find<DesktopController>().toggleWindow('notepad');
    currentFile.value = null;
  }
}