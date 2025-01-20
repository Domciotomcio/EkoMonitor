import 'package:flutter/material.dart';

class WeatherForecastView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: Center(
        child: Text('Weather Forecast Content'),
      ),
    );
  }
}
