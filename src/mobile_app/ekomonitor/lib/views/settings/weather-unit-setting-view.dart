import 'package:flutter/material.dart';

import 'weather-settings-view.dart';

class WeatherUnitSettingView extends StatelessWidget {
  final WeatherCondition weatherCondition;

  const WeatherUnitSettingView({super.key, required this.weatherCondition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherCondition.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            weatherCondition.icon,
            const SizedBox(height: 16),
            Text(
              weatherCondition.name,
            ),
          ],
        ),
      ),
    );
  }
}
