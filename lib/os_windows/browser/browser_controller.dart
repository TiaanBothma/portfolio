// os_windows/browser/browser_controller.dart
import 'package:get/get.dart';
import 'package:portfolio/controllers/window_state.dart';

class BrowserTab {
  final String id;
  String title;
  String url;

  BrowserTab({required this.id, required this.title, required this.url});
}

class BrowserController extends GetxController {
  final tabs = <BrowserTab>[].obs;
  final activeTabId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    openNewTab();
  }

  BrowserTab? get activeTab {
    if (activeTabId.value.isEmpty) return null;
    return tabs.firstWhereOrNull((t) => t.id == activeTabId.value);
  }

  void openNewTab({String title = 'New Tab', String url = 'home'}) {
    final tab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      url: url,
    );
    tabs.add(tab);
    activeTabId.value = tab.id;
  }

  void closeTab(String id) {
    final index = tabs.indexWhere((t) => t.id == id);
    if (index == -1) return;

    tabs.removeAt(index);

    if (tabs.isEmpty) {
      // No tabs left — close the browser
      Get.find<DesktopController>().toggleWindow('browser');
      return;
    }

    // If we closed the active tab, activate the nearest one
    if (activeTabId.value == id) {
      final newIndex = (index - 1).clamp(0, tabs.length - 1);
      activeTabId.value = tabs[newIndex].id;
    }
  }

  void switchTab(String id) {
    activeTabId.value = id;
  }

  void navigateTo(String url, String title) {
    final tab = activeTab;
    if (tab == null) return;
    final index = tabs.indexWhere((t) => t.id == tab.id);
    tabs[index].url = url;
    tabs[index].title = title;
    tabs.refresh();
  }
}
