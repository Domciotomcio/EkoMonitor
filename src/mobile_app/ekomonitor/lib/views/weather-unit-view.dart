import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:flutter/material.dart';

class WeatherUnitView extends StatelessWidget {
  final WthrConDesc weatherCondition;

  WeatherUnitView({
    super.key,
    required this.weatherCondition,
  });

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
            Container(
              width: 400,
              height: 400,
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Center(child: Text("Presentation")),
            ),
          ],
        ),
      ),
    );
  }
}
