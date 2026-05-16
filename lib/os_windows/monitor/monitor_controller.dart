import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';

class ProcessInfo {
  final String name;
  final String exe;
  final double baseCpu;
  final double baseMem;
  final int memMb;

  const ProcessInfo({
    required this.name,
    required this.exe,
    required this.baseCpu,
    required this.baseMem,
    required this.memMb,
  });
}

class MonitorController extends GetxController {
  final Random _random = Random();
  Timer? _timer;

  final cpuValue = 0.94.obs;
  final memValue = 0.80.obs;
  final netValue = 0.70.obs;
  final dskValue = 0.60.obs;

  final cpuHistory = <double>[].obs;

  final RxList<Map<String, dynamic>> processes = <Map<String, dynamic>>[].obs;

  static const List<ProcessInfo> _baseProcesses = [
    ProcessInfo(
      name: 'Flutter',
      exe: 'flutter.exe',
      baseCpu: 0.94,
      baseMem: 0.88,
      memMb: 512,
    ),
    ProcessInfo(
      name: 'Firebase',
      exe: 'firebase.exe',
      baseCpu: 0.80,
      baseMem: 0.75,
      memMb: 384,
    ),
    ProcessInfo(
      name: 'Dart',
      exe: 'dart.exe',
      baseCpu: 0.72,
      baseMem: 0.60,
      memMb: 280,
    ),
    ProcessInfo(
      name: 'Docker',
      exe: 'docker.exe',
      baseCpu: 0.60,
      baseMem: 0.55,
      memMb: 256,
    ),
    ProcessInfo(
      name: 'Python',
      exe: 'python.exe',
      baseCpu: 0.70,
      baseMem: 0.45,
      memMb: 128,
    ),
    ProcessInfo(
      name: 'Git',
      exe: 'git.exe',
      baseCpu: 0.30,
      baseMem: 0.20,
      memMb: 64,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _initHistory();
    _initProcesses();
    _startTick();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _initHistory() {
    for (int i = 0; i < 40; i++) {
      cpuHistory.add(0.85 + _random.nextDouble() * 0.12);
    }
  }

  void _initProcesses() {
    processes.assignAll(
      _baseProcesses.map<Map<String, dynamic>>(
        (p) => {
          'name': p.name,
          'exe': p.exe,
          'cpu': p.baseCpu,
          'mem': p.memMb,
          'baseCpu': p.baseCpu,
        },
      ),
    );
  }

  void _startTick() {
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) => _tick());
  }

  void _tick() {
    cpuValue.value = _fluctuate(cpuValue.value, 0.88, 0.99, 0.03);
    memValue.value = _fluctuate(memValue.value, 0.75, 0.88, 0.02);
    netValue.value = _fluctuate(netValue.value, 0.55, 0.80, 0.04);
    dskValue.value = _fluctuate(dskValue.value, 0.50, 0.72, 0.03);

    cpuHistory.add(cpuValue.value);
    if (cpuHistory.length > 40) cpuHistory.removeAt(0);

    processes.assignAll(
      processes.map<Map<String, dynamic>>((current) {
        final base = current['baseCpu'] as double;

        return {
          'name': current['name'],
          'exe': current['exe'],
          'cpu': _fluctuate(
            current['cpu'] as double,
            base - 0.08,
            base + 0.05,
            0.03,
          ),
          'mem': current['mem'],
          'baseCpu': current['baseCpu'],
        };
      }).toList(),
    );
  }

  double _fluctuate(double current, double min, double max, double delta) {
    final change = (_random.nextDouble() - 0.5) * 2 * delta;
    return (current + change).clamp(min, max);
  }

  void open() {
    Get.find<DesktopController>().toggleWindow('monitor');
  }
}
