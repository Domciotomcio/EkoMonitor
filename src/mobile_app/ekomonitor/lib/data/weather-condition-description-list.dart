import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:flutter/material.dart';

List<WthrConDesc> wthrConDescList = [
  WthrConDesc(
      name: "precipitation",
      fixedName: "precipitation",
      icon: Icon(Icons.umbrella_outlined),
      path: 'rainfall',
      description: 'Precipitation in millimeters'),
  WthrConDesc(
      name: "precipitation probability",
      fixedName: "precipitation_probability",
      icon: Icon(Icons.umbrella_outlined),
      path: 'rainfall',
      description: 'Precipitation probability in percent'),
  WthrConDesc(
      name: "cloudiness",
      fixedName: "cloudiness",
      icon: Icon(Icons.cloud_outlined),
      path: 'clouds',
      description: 'Cloudiness in percent'),
  WthrConDesc(
      name: "Temperatura",
      fixedName: "temperature",
      icon: Icon(Icons.thermostat_outlined),
      path: 'temperature',
      description: 'Temperature in Celsius'),
  WthrConDesc(
      name: "Ciśnienie atmosferyczne",
      fixedName: "pressure",
      icon: Icon(Icons.thermostat_outlined),
      path: 'pressure',
      description: 'Atmospheric pressure in hPa'),
  WthrConDesc(
      name: "Wilgotność",
      fixedName: "humidity",
      icon: Icon(Icons.device_thermostat_outlined),
      path: 'humidity',
      description: 'Humidity in percent'),
  WthrConDesc(
      name: "Widoczność",
      fixedName: "visibility",
      icon: Icon(Icons.view_agenda_outlined),
      path: 'visibility',
      description: 'Visibility in meters'),
  WthrConDesc(
      name: "Prędkość wiatru",
      fixedName: "wind_speed",
      icon: Icon(Icons.wind_power_outlined),
      path: 'wind-speed',
      description: 'Prędkość wiatru w m/s'),
  WthrConDesc(
      name: "Kierunek wiatru",
      fixedName: "wind_direction",
      icon: Icon(Icons.wind_power_outlined),
      path: 'wind-direction',
      description: 'Kierunek wiatru w stopniach'),
  WthrConDesc(
      name: "Stęzenie pyłków PM 10",
      fixedName: "pm10",
      icon: Icon(Icons.checklist_rounded),
      path: 'pm10',
      description: 'Stęzenie pyłków PM 10 w µg/m³'),
  WthrConDesc(
      name: "Stęzenie pyłków PM 2.5",
      fixedName: "pm2_5",
      icon: Icon(Icons.checklist_rounded),
      path: 'pm25',
      description: 'Stęzenie pyłków PM 2.5 w µg/m³'),
  WthrConDesc(
      name: "Jakosc powietrza",
      fixedName: "aqi",
      icon: Icon(Icons.checklist_rounded),
      path: 'pm25',
      description: 'Stęzenie pyłków PM 2.5 w µg/m³'),
];

Map<String, WthrConDesc> wthrConDescMap = {
  'precipitation': wthrConDescList[0],
  'precipitation_probability': wthrConDescList[1],
  'cloudiness': wthrConDescList[2],
  'temperature': wthrConDescList[3],
  'pressure': wthrConDescList[4],
  'humidity': wthrConDescList[5],
  'visibility': wthrConDescList[6],
  'wind_speed': wthrConDescList[7],
  'wind_direction': wthrConDescList[8],
  'pm10': wthrConDescList[9],
  'pm2_5': wthrConDescList[9],
  'aqi': wthrConDescList[10],
};
