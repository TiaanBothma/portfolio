import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static const _keyWallpaper = 'wallpaper';
  static const _keyTransparency = 'transparency';
  static const _keyClock24hr = 'clock24hr';
  static const _keyPaletteIndex = 'paletteIndex';
  static const _keyCursorStyle = 'cursorStyle';

  // Observables
  final wallpaper = 'neural'.obs;
  final windowTransparency = 0.92.obs;
  final clock24hr = true.obs;
  final paletteIndex = 0.obs;
  final cursorStyle = 'line'.obs;

  // Full palette presets
  static const List<Map<String, dynamic>> palettes = [
    {
      'name': 'Midnight Blue',
      'black': Color(0xFF02010A),
      'deepAccent': Color(0xFF04052E),
      'darkSecondary': Color(0xFF140152),
      'secondary': Color(0xFF22007C),
      'accent': Color(0xFF0D00A4),
    },
    {
      'name': 'Deep Purple',
      'black': Color(0xFF08010A),
      'deepBlue': Color(0xFF1A0230),
      'darkPurple': Color(0xFF2D0152),
      'purple': Color(0xFF4A007C),
      'accent': Color(0xFF7B00A4),
    },
    {
      'name': 'Hacker Green',
      'black': Color(0xFF010A02),
      'deepBlue': Color(0xFF012E08),
      'darkPurple': Color(0xFF015214),
      'purple': Color(0xFF007C22),
      'accent': Color(0xFF00A43B),
    },
    {
      'name': 'Cyber Cyan',
      'black': Color(0xFF01090A),
      'deepBlue': Color(0xFF012B2E),
      'darkPurple': Color(0xFF014A52),
      'purple': Color(0xFF007580),
      'accent': Color(0xFF009DA4),
    },
    {
      'name': 'Blood Red',
      'black': Color(0xFF0A0101),
      'deepBlue': Color(0xFF2E0202),
      'darkPurple': Color(0xFF520101),
      'purple': Color(0xFF7C0000),
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
  Color get black => palette['black'] as Color;
  Color get deepBlue => palette['deepBlue'] as Color;
  Color get darkPurple => palette['darkPurple'] as Color;
  Color get purple => palette['purple'] as Color;

  // The accent color dot shown in the palette picker
  // Returns just the accent color of each palette for the circle preview
  static Color paletteAccent(int index) => palettes[index]['accent'] as Color;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    wallpaper.value = prefs.getString(_keyWallpaper) ?? 'neural';
    windowTransparency.value = prefs.getDouble(_keyTransparency) ?? 0.92;
    clock24hr.value = prefs.getBool(_keyClock24hr) ?? true;
    paletteIndex.value = prefs.getInt(_keyPaletteIndex) ?? 0;
    cursorStyle.value = prefs.getString(_keyCursorStyle) ?? 'line';
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

  Future<void> setCursorStyle(String style) async {
    cursorStyle.value = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCursorStyle, style);
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    wallpaper.value = 'neural';
    windowTransparency.value = 0.92;
    clock24hr.value = true;
    paletteIndex.value = 0;
    cursorStyle.value = 'line';
  }
}
