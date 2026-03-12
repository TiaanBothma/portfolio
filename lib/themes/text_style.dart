import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // Oxanium - UI Text
  static TextStyle display = GoogleFonts.oxanium(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle heading = GoogleFonts.oxanium(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle body = GoogleFonts.oxanium(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static TextStyle label = GoogleFonts.oxanium(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );

  // JetBrains Mono - Terminal only
  static TextStyle terminal = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static TextStyle terminalCommand = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}