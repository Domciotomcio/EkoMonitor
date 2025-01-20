import 'package:ekomonitor/models/weather_condition_description.dart';
import 'package:flutter/material.dart';

import 'weather-settings-view.dart';

class WeatherUnitSettingView extends StatelessWidget {
  final WthrConDesc weatherCondition;

  const WeatherUnitSettingView({super.key, required this.weatherCondition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherCondition.name),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(weatherCondition.icon.icon, size: 100),
            Text(weatherCondition.name),
            SizedBox(height: 16),
            ListTile(
              title: Text('Uwzględnij w prognozie'),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
          ],
        ),
      ),
    );
  }
}
