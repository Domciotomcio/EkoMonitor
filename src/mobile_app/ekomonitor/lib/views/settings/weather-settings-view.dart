import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:flutter/material.dart';

class WeatherSettingsView extends StatelessWidget {
  const WeatherSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather settings'),
      ),
      body: ListView.builder(
        itemCount: wthrConDescList.length,
        itemBuilder: (context, index) {
          final weatherUnit = wthrConDescList[index];
          return ListTile(
            title: Text(weatherUnit.name),
            leading: Icon(weatherUnit.icon.icon,
                color: Theme.of(context).colorScheme.primary),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed(weatherUnit.settingsPath);
            },
          );
        },
      ),
    );
  }
}
