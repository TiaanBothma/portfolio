import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static const _keyWallpaper = 'wallpaper';
  static const _keyTransparency = 'transparency';
  static const _keyClock24hr = 'clock24hr';
  static const _keyPaletteIndex = 'paletteIndex';
  static const _keyCursorStyle = 'cursorStyle';
  static const _keyShowDate = 'showDate';
  static const _keyShowStatusCard = 'showStatusCard';
  static const _keyDockPosition = 'dockPosition';
  static const _keyTerminalFontSize = 'terminalFontSize';
  static const _keyShowDockLabels = 'showDockLabels';
  static const _keyTerminalWelcome = 'terminalWelcome';
  static const _keyAnimationSpeed = 'animationSpeed';

  // Observables
  final wallpaper = 'neural'.obs;
  final windowTransparency = 0.92.obs;
  final clock24hr = true.obs;
  final paletteIndex = 0.obs;
  final cursorStyle = 'line'.obs;
  final showDate = true.obs;
  final showStatusCard = true.obs;
  final dockPosition = 'bottom'.obs;
  final terminalFontSize = 13.0.obs;
  final showDockLabels = true.obs;
  final terminalWelcome = 'message'.obs;
  final animationSpeed = 1.0.obs;

  // Full palette presets
  static const List<Map<String, dynamic>> palettes = [
    /*
    !! AppColors.black     - settings.background
    !! AppColors.deepBlue  - settings.surface
    !! AppColors.darkPurple- settings.surfaceAlt
    !! AppColors.purple    - settings.muted
    !! AppColors.blue      - settings.accent
    */
    {
      'name': 'Midnight Blue',
      'background': Color(0xFF02010A),
      'surface': Color(0xFF04052E),
      'surfaceAlt': Color(0xFF140152),
      'muted': Color(0xFF22007C),
      'accent': Color(0xFF0D00A4),
    },
    {
      'name': 'Deep Purple',
      'background': Color(0xFF08010A),
      'surface': Color(0xFF1A0230),
      'surfaceAlt': Color(0xFF2D0152),
      'muted': Color(0xFF4A007C),
      'accent': Color(0xFF7B00A4),
    },
    {
      'name': 'Hacker Green',
      'background': Color(0xFF010A02),
      'surface': Color(0xFF012E08),
      'surfaceAlt': Color(0xFF015214),
      'muted': Color(0xFF007C22),
      'accent': Color(0xFF00A43B),
    },
    {
      'name': 'Cyber Cyan',
      'background': Color(0xFF01090A),
      'surface': Color(0xFF012B2E),
      'surfaceAlt': Color(0xFF014A52),
      'muted': Color(0xFF007580),
      'accent': Color(0xFF009DA4),
    },
    {
      'name': 'Blood Red',
      'background': Color(0xFF0A0101),
      'surface': Color(0xFF2E0202),
      'surfaceAlt': Color(0xFF520101),
      'muted': Color(0xFF7C0000),
      'accent': Color(0xFFA40000),
    },
  ];

  // Wallpaper options
  static const List<Map<String, dynamic>> wallpapers = [
    {
      'id': 'neural',
      'label': 'Neural Network',
      'description': 'Interactive dynamic wallpaper',
      'isLive': true,
    },
    {
      'id': 'wallpaper',
      'label': 'Windows Dark',
      'description': 'Windows 11 dark blue',
      'isLive': false,
    },
    {
      'id': 'wallpaper2',
      'label': 'Deep Space',
      'description': 'Dark cosmic gradient',
      'isLive': false,
    },
    {
      'id': 'wallpaper3',
      'label': 'Midnight Purple',
      'description': 'Deep purple gradient',
      'isLive': false,
    },
  ];

  // Current palette getters — use these everywhere instead of AppColors
  Map<String, dynamic> get palette => palettes[paletteIndex.value];
  Color get accentColor => palette['accent'] as Color;
  Color get background => palette['background'] as Color;
  Color get surface => palette['surface'] as Color;
  Color get surfaceAlt => palette['surfaceAlt'] as Color;
  Color get muted => palette['muted'] as Color;

  static Color paletteAccent(int index) => palettes[index]['accent'] as Color;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Check for previous underline settings applied
    final savedCursor = prefs.getString(_keyCursorStyle) ?? 'line';
    cursorStyle.value = ['line', 'block'].contains(savedCursor)
        ? savedCursor
        : 'line';

    wallpaper.value = prefs.getString(_keyWallpaper) ?? 'neural';
    windowTransparency.value = prefs.getDouble(_keyTransparency) ?? 0.92;
    clock24hr.value = prefs.getBool(_keyClock24hr) ?? true;
    paletteIndex.value = prefs.getInt(_keyPaletteIndex) ?? 0;
    cursorStyle.value = prefs.getString(_keyCursorStyle) ?? 'line';
    showDate.value = prefs.getBool(_keyShowDate) ?? true;
    showStatusCard.value = prefs.getBool(_keyShowStatusCard) ?? true;
    dockPosition.value = prefs.getString(_keyDockPosition) ?? 'bottom';
    terminalFontSize.value = prefs.getDouble(_keyTerminalFontSize) ?? 13.0;
    showDockLabels.value = prefs.getBool(_keyShowDockLabels) ?? true;
    terminalWelcome.value = prefs.getString(_keyTerminalWelcome) ?? 'message';
  }

  Future<void> setWallpaper(String id) async {
    wallpaper.value = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWallpaper, id);
  }

  Future<void> setTransparency(double value) async {
    windowTransparency.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTransparency, value);
  }

  Future<void> setClock24hr(bool value) async {
    clock24hr.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyClock24hr, value);
  }

  Future<void> setAccentColor(int index) async {
    paletteIndex.value = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPaletteIndex, index);
  }

  Future<void> setShowDate(bool value) async {
    showDate.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowDate, value);
  }

  Future<void> setAnimationSpeed(double value) async {
    animationSpeed.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyAnimationSpeed, value);
  }

  Future<void> setShowStatusCard(bool value) async {
    showStatusCard.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowStatusCard, value);
  }

  Future<void> setCursorStyle(String style) async {
    cursorStyle.value = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCursorStyle, style);
  }

  Future<void> setDockPosition(String position) async {
    dockPosition.value = position;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDockPosition, position);
  }

  Future<void> setTerminalFontSize(double size) async {
    terminalFontSize.value = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTerminalFontSize, size);
  }

  Future<void> setShowDockLabels(bool value) async {
    showDockLabels.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowDockLabels, value);
  }

  Future<void> setTerminalWelcome(String value) async {
    terminalWelcome.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTerminalWelcome, value);
  }

  Duration get windowAnimDuration =>
      Duration(milliseconds: (180 * animationSpeed.value).toInt());

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    wallpaper.value = 'neural';
    windowTransparency.value = 0.92;
    clock24hr.value = true;
    paletteIndex.value = 0;
    cursorStyle.value = 'line';
    showDate.value = true;
    showStatusCard.value = true;
    dockPosition.value = 'bottom';
    terminalFontSize.value = 13.0;
    showDockLabels.value = true;
    terminalWelcome.value = 'message';
    await prefs.remove(_keyShowStatusCard);
    await prefs.remove(_keyShowDate);
    await prefs.remove(_keyDockPosition);
    await prefs.remove(_keyTerminalFontSize);
    await prefs.remove(_keyShowDockLabels);
    await prefs.remove(_keyTerminalWelcome);
    animationSpeed.value = 1.0;
    await prefs.remove(_keyAnimationSpeed);
  }
}
