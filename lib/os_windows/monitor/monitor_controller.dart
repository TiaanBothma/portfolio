import 'dart:async';
import 'dart:js_interop';
import 'dart:math';
import 'package:get/get.dart';
import 'package:portfolio/controllers/desktop_controller.dart';
import 'package:portfolio/controllers/settings_controller.dart';

@JS('performance.memory.usedJSHeapSize')
external JSNumber? get _usedJSHeapSize;

@JS('performance.memory.totalJSHeapSize')
external JSNumber? get _totalJSHeapSize;

class ProcessInfo {
  final String name;
  final String exe;
  final double baseCpu;
  final double baseMem;
  final int memMb;
  final String? windowId;
  final String action;
  final bool protected;

  const ProcessInfo({
    required this.name,
    required this.exe,
    required this.baseCpu,
    required this.baseMem,
    required this.memMb,
    this.windowId,
    this.action = 'kill',
    this.protected = false,
  });
}

class MonitorController extends GetxController {
  final Random _random = Random();
  Timer? _timer;

  final cpuValue = 0.94.obs;
  final memValue = 0.80.obs;
  final netValue = 0.70.obs;
  final dskValue = 0.60.obs;
  final webHeapMb = 0.obs;
  final webHeapTotalMb = 0.obs;
  final webHeapSupported = false.obs;
  final traceRunning = false.obs;
  final traceProgress = 0.0.obs;
  final traceLog = 'Idle. Select Run Trace to scan active OS services.'.obs;

  final cpuHistory = <double>[].obs;

  final RxList<Map<String, dynamic>> processes = <Map<String, dynamic>>[].obs;

  static const List<ProcessInfo> _baseProcesses = [
    ProcessInfo(
      name: 'Flutter',
      exe: 'flutter.exe',
      baseCpu: 0.94,
      baseMem: 0.88,
      memMb: 512,
      windowId: 'browser',
    ),
    ProcessInfo(
      name: 'Firebase',
      exe: 'firebase.exe',
      baseCpu: 0.80,
      baseMem: 0.75,
      memMb: 384,
      protected: true,
      action: 'service',
    ),
    ProcessInfo(
      name: 'Dart',
      exe: 'dart.exe',
      baseCpu: 0.72,
      baseMem: 0.60,
      memMb: 280,
      windowId: 'terminal',
    ),
    ProcessInfo(
      name: 'Docker',
      exe: 'docker.exe',
      baseCpu: 0.60,
      baseMem: 0.55,
      memMb: 256,
      windowId: 'vault',
    ),
    ProcessInfo(
      name: 'Python',
      exe: 'python.exe',
      baseCpu: 0.70,
      baseMem: 0.45,
      memMb: 128,
      windowId: 'settings',
    ),
    ProcessInfo(
      name: 'Git',
      exe: 'git.exe',
      baseCpu: 0.30,
      baseMem: 0.20,
      memMb: 64,
      action: 'background',
    ),
    ProcessInfo(
      name: 'Status Widget',
      exe: 'status_card.dart',
      baseCpu: 0.18,
      baseMem: 0.16,
      memMb: 42,
      action: 'hide',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _initHistory();
    _initProcesses();
    ever<bool>(Get.find<SettingsController>().showStatusCard, (visible) {
      if (visible) {
        _ensureStatusCardProcess();
      } else {
        processes.removeWhere((p) => p['exe'] == 'status_card.dart');
      }
    });
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
        _processToMap,
      ),
    );
  }

  Map<String, dynamic> _processToMap(ProcessInfo p) {
    return <String, dynamic>{
      'name': p.name,
      'exe': p.exe,
      'cpu': p.baseCpu,
      'mem': p.memMb,
      'baseCpu': p.baseCpu,
      'windowId': p.windowId,
      'action': p.action,
      'protected': p.protected,
    };
  }

  void _ensureStatusCardProcess() {
    final exists = processes.any((p) => p['exe'] == 'status_card.dart');
    if (exists) return;

    final statusProcess = _baseProcesses.firstWhere(
      (p) => p.exe == 'status_card.dart',
    );
    processes.add(_processToMap(statusProcess));
  }

  void _startTick() {
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) => _tick());
  }

  void _tick() {
    _updateWebMemory();

    cpuValue.value = _fluctuate(cpuValue.value, 0.88, 0.99, 0.03);
    memValue.value = webHeapSupported.value
        ? (webHeapMb.value / 256).clamp(0.12, 0.98).toDouble()
        : _fluctuate(memValue.value, 0.75, 0.88, 0.02);
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
          'windowId': current['windowId'],
          'action': current['action'],
          'protected': current['protected'],
        };
      }).toList(),
    );
  }

  void _updateWebMemory() {
    try {
      final used = _usedJSHeapSize?.toDartDouble;
      final total = _totalJSHeapSize?.toDartDouble;
      if (used == null || total == null) {
        webHeapSupported.value = false;
        return;
      }

      webHeapMb.value = (used / 1024 / 1024).round();
      webHeapTotalMb.value = (total / 1024 / 1024).round();
      webHeapSupported.value = true;
    } catch (_) {
      webHeapSupported.value = false;
    }
  }

  double _fluctuate(double current, double min, double max, double delta) {
    final change = (_random.nextDouble() - 0.5) * 2 * delta;
    return (current + change).clamp(min, max);
  }

  void open() {
    Get.find<DesktopController>().toggleWindow('monitor');
  }

  void endProcess(Map<String, dynamic> process) {
    if (process['protected'] == true) return;

    final exe = process['exe'] as String;
    final windowId = process['windowId'] as String?;

    if (process['action'] == 'hide') {
      Get.find<SettingsController>().showStatusCard.value = false;
    } else if (windowId != null) {
      final desktop = Get.find<DesktopController>();
      final window = desktop.getWindowRx(windowId);
      final current = window.value;
      window.value = WindowState(
        offset: current.offset,
        size: current.size,
        isOpen: false,
      );
    }

    processes.removeWhere((p) => p['exe'] == exe);
    traceLog.value = '$exe ended for this session.';
  }

  void restoreSession() {
    Get.find<SettingsController>().showStatusCard.value = true;
    _initProcesses();
    traceLog.value = 'Session processes restored.';
  }

  void runTrace() {
    if (traceRunning.value) return;

    traceRunning.value = true;
    traceProgress.value = 0;
    traceLog.value = 'Scanning active services...';

    var step = 0;
    Timer.periodic(const Duration(milliseconds: 180), (timer) {
      step++;
      traceProgress.value = step / 10;

      if (step == 3) traceLog.value = 'Checking heap pressure...';
      if (step == 6) traceLog.value = 'Checking UI processes...';
      if (step == 9) traceLog.value = 'Finalizing recommendations...';

      if (step >= 10) {
        timer.cancel();
        traceRunning.value = false;
        final heavy = processes
            .where((p) => (p['cpu'] as double) > 0.65)
            .map((p) => p['exe'] as String)
            .join(', ');
        traceLog.value = heavy.isEmpty
            ? 'Trace complete. No high-load processes detected.'
            : 'Trace complete. High-load: $heavy';
      }
    });
  }
}
