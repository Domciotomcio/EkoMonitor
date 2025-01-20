import 'package:flutter/material.dart';

class SettingsTileConfig {
  final String text;
  final Color color;
  final Icon icon;
  final String path;

  const SettingsTileConfig(
      {this.text = "Ustawienia",
      this.color = Colors.grey,
      this.icon = const Icon(Icons.settings),
      this.path = "/"});
}

class SettingsTile extends StatelessWidget {
  final SettingsTileConfig config;

  const SettingsTile({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, config.path),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: config.color),
        ),
        margin: const EdgeInsets.all(4),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    config.icon.icon,
                    color: config.color,
                    size: 32,
                  ),
                ],
              ),
              Text(
                config.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
