import 'package:flutter/material.dart';

const List<WeatherCondition> weatherUnits = [
  WeatherCondition(
      name: "Ilość opadów", icon: Icon(Icons.ac_unit), path: 'rainfall'),
  WeatherCondition(
      name: "Pokrycie chmur", icon: Icon(Icons.ac_unit), path: 'clouds'),
  WeatherCondition(
      name: "Temperatura", icon: Icon(Icons.ac_unit), path: 'temperature'),
  WeatherCondition(
      name: "Ciśnienie atmosferyczne",
      icon: Icon(Icons.ac_unit),
      path: 'pressure'),
  WeatherCondition(
      name: "Wilgotność", icon: Icon(Icons.ac_unit), path: 'humidity'),
  WeatherCondition(
      name: "Widoczność", icon: Icon(Icons.ac_unit), path: 'visibility'),
  WeatherCondition(
      name: "Prędkość wiatru", icon: Icon(Icons.ac_unit), path: 'wind-speed'),
  WeatherCondition(
      name: "Kierunek wiatru",
      icon: Icon(Icons.ac_unit),
      path: 'wind-direction'),
  WeatherCondition(
      name: "Stęzenie pyłków PM 10", icon: Icon(Icons.ac_unit), path: 'pm10'),
  WeatherCondition(
      name: "Stęzenie pyłków PM 2.5", icon: Icon(Icons.ac_unit), path: 'pm25'),
];

class WeatherSettingsView extends StatelessWidget {
  const WeatherSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia pogody'),
      ),
      body: ListView.builder(
        itemCount: weatherUnits.length,
        itemBuilder: (context, index) {
          final weatherUnit = weatherUnits[index];
          return ListTile(
            title: Text(weatherUnit.name),
            leading: weatherUnit.icon,
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

class WeatherCondition {
  final String name;
  final Icon icon;
  final String path;

  const WeatherCondition({
    required this.name,
    required this.icon,
    required this.path,
  });

  String get settingsPath => '/weather-settings/$path';
}
