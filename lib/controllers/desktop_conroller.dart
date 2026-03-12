// presentation/controllers/desktop_controller.dart
import 'package:get/get.dart';

class DesktopController extends GetxController {
  final terminalOpen = false.obs;

  void toggleTerminal() => terminalOpen.toggle();
}