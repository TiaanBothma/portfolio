import 'package:get/get.dart';

class StartMenuController extends GetxController {
  final isOpen = false.obs;

  void toggle() => isOpen.value = !isOpen.value;
  void close() => isOpen.value = false;
}