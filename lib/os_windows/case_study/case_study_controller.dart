import 'package:get/get.dart';
import 'package:portfolio/data/case_studies_data.dart';

class CaseStudyController extends GetxController {
  final selectedIndex = 0.obs;

  CaseStudy get selected => CaseStudiesData.all[selectedIndex.value];

  void select(int index) {
    if (index < 0 || index >= CaseStudiesData.all.length) return;
    selectedIndex.value = index;
  }

  void openProject(String key) {
    final normalized = key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final index = CaseStudiesData.all.indexWhere((study) {
      final name = study.projectName
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]'), '');
      return name.contains(normalized) || normalized.contains(name);
    });

    if (index != -1) select(index);
  }
}
