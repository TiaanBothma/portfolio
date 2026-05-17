import 'package:get/get.dart';
import 'package:portfolio/data/timeline_data.dart';

class TimelineController extends GetxController {
  final selectedIndex = Rx<int?>(null);

  TimelineEvent? get selectedEvent => selectedIndex.value != null
      ? TimelineData.events[selectedIndex.value!]
      : null;

  void selectEvent(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = null; // tap again to deselect
    } else {
      selectedIndex.value = index;
    }
  }

  void clearSelection() {
    selectedIndex.value = null;
  }
}
