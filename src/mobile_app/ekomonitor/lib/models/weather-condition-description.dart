import 'package:flutter/material.dart';

class WthrConDesc {
  final String name;
  final Icon icon;
  final String path;
  final String description;

  const WthrConDesc({
    required this.name,
    required this.description,
    required this.icon,
    required this.path,
  });

  String get settingsPath => '/weather-settings/$path';
}
