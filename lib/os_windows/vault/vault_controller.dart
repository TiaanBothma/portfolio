import 'package:get/get.dart';
import 'package:portfolio/data/file_system_data.dart';

class VaultController extends GetxController {
  final currentFolder = Rx<VaultFolder>(FileSystemData.root);
  final selectedFile = Rx<VaultFile?>(null);
  final selectedFolder = Rx<VaultFolder?>(null);
  final navigationStack = <VaultFolder>[].obs;

  String get currentPath {
    if (navigationStack.isEmpty) return '~/${currentFolder.value.name}';
    final path = navigationStack.map((f) => f.name).join('/');
    return '~/$path/${currentFolder.value.name}';
  }

  void openFolder(VaultFolder folder) {
    navigationStack.add(currentFolder.value);
    currentFolder.value = folder;
    selectedFile.value = null;
    selectedFolder.value = null;
  }

  void goBack() {
    if (navigationStack.isEmpty) return;
    currentFolder.value = navigationStack.removeLast();
    selectedFile.value = null;
    selectedFolder.value = null;
  }

  void goHome() {
    navigationStack.clear();
    currentFolder.value = FileSystemData.root;
    selectedFile.value = null;
    selectedFolder.value = null;
  }

  void selectFile(VaultFile file) {
    selectedFile.value = file;
    selectedFolder.value = null;
  }

  void selectFolder(VaultFolder folder) {
    selectedFolder.value = folder;
    selectedFile.value = null;
  }

  bool get canGoBack => navigationStack.isNotEmpty;
}