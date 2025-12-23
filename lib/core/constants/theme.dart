import 'package:flutter/material.dart';

class Theme {
  static const Color dark = Colors.black;
  static const Color light = Colors.white;
  static const acceptedThemes = [dark, light];
  static const defaultTheme = dark;

  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: defaultTheme,
      scaffoldBackgroundColor: defaultTheme,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
    );
  }
}
