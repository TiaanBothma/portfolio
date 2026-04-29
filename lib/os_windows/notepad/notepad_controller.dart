import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/data/file_system_data.dart';

class NotepadController extends GetxController {
  final currentFile = Rx<VaultFile?>(null);

  // View settings
  final fontSize = 12.0.obs;
  final wordWrap = true.obs;
  final showLineNumbers = false.obs;

  // Find
  final showFind = false.obs;
  final findQuery = ''.obs;
  final findController = TextEditingController();

  // Menu
  final activeMenu = Rx<String?>(null);

  @override
  void onClose() {
    findController.dispose();
    super.onClose();
  }

  void openFile(VaultFile file) {
    currentFile.value = file;
    Get.find<DesktopController>().toggleWindow('notepad');
  }

  void close() {
    Get.find<DesktopController>().toggleWindow('notepad');
    currentFile.value = null;
    showFind.value = false;
    activeMenu.value = null;
  }

  void backToVault() {
    Get.find<DesktopController>().toggleWindow('notepad');
    Get.find<DesktopController>().toggleWindow('vault');
    activeMenu.value = null;
  }

  void print() {
    activeMenu.value = null;
  }

  void copyAll() {
    final file = currentFile.value;
    if (file == null) return;
    final text = file.imagePath != null ? file.name : file.content;
    Clipboard.setData(ClipboardData(text: text));
    activeMenu.value = null;
  }

  void toggleFind() {
    showFind.value = !showFind.value;
    if (!showFind.value) {
      findQuery.value = '';
      findController.clear();
    }
    activeMenu.value = null;
  }

  void increaseFontSize() {
    if (fontSize.value < 24) fontSize.value += 1;
  }

  void decreaseFontSize() {
    if (fontSize.value > 8) fontSize.value -= 1;
  }

  void toggleWordWrap() {
    wordWrap.value = !wordWrap.value;
    activeMenu.value = null;
  }

  void toggleLineNumbers() {
    showLineNumbers.value = !showLineNumbers.value;
    activeMenu.value = null;
  }

  void toggleMenu(String menu) {
    activeMenu.value = activeMenu.value == menu ? null : menu;
  }

  void closeMenu() {
    activeMenu.value = null;
  }
}