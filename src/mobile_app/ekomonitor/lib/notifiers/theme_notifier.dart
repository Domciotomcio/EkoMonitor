import 'package:ekomonitor/themes/theme1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(theme1);

  void setTheme(ThemeData theme) {
    state = theme;
  }

  void setThemeByColor(Color color) {
    state = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: color),
      brightness: Brightness.light,
      useMaterial3: true
    );
  }
}