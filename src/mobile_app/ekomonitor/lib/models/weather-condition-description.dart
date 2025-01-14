import 'package:flutter/material.dart';

class WthrConDesc {
  final String name;
  final String fixedName;
  final Icon icon;
  final String path;
  final String description;

  const WthrConDesc({
    required this.name,
    required this.fixedName,
    required this.description,
    required this.icon,
    required this.path,
  });

  String get settingsPath => '/weather-settings/$path';

  // TODO: icon and what about path?
  factory WthrConDesc.fromJson(Map<String, dynamic> json) {
    return WthrConDesc(
      name: json['name'],
      fixedName: json['fixedName'],
      description: json['description'],
      icon: Icon(Icons.cloud_outlined),
      path: json['path'],
    );
  }
}
