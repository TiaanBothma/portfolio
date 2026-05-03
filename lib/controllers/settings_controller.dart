import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static const _keyWallpaper = 'wallpaper';
  static const _keyTransparency = 'transparency';
  static const _keyClock24hr = 'clock24hr';
  static const _keyAccentColor = 'accentColor';
  static const _keyCursorStyle = 'cursorStyle';

  // Observables
  final wallpaper = 'neural'.obs;
  final windowTransparency = 0.92.obs;
  final clock24hr = true.obs;
  final accentColorIndex = 0.obs;
  final cursorStyle = 'line'.obs;

  // Accent color presets
  static const List<Color> accentColors = [
    Color(0xFF0D00A4), // original blue
    Color(0xFF6B00A4), // purple
    Color(0xFF00A4A4), // cyan
    Color(0xFF00A44B), // hacker green
    Color(0xFFA40000), // deep red
  ];

  Color get accentColor => accentColors[accentColorIndex.value];
  double get alpha => windowTransparency.value;
  static Color get accent => Get.find<SettingsController>().accentColor;

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
    accentColorIndex.value = prefs.getInt(_keyAccentColor) ?? 0;
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
    accentColorIndex.value = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAccentColor, index);
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
    accentColorIndex.value = 0;
    cursorStyle.value = 'line';
  }
}
