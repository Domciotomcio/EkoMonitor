import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:flutter/material.dart';

List<WthrConDesc> wthrConDescList = [
  WthrConDesc(
      name: "Ilość opadów",
      icon: Icon(Icons.umbrella_outlined),
      path: 'rainfall',
      description: 'Ilość opadów w milimetrach'),
  WthrConDesc(
      name: "Pokrycie chmur",
      icon: Icon(Icons.cloud_outlined),
      path: 'clouds',
      description: 'Pokrycie chmur w procentach'),
  WthrConDesc(
      name: "Temperatura",
      icon: Icon(Icons.thermostat_outlined),
      path: 'temperature',
      description: 'Temperatura w stopniach Celsjusza'),
  WthrConDesc(
      name: "Ciśnienie atmosferyczne",
      icon: Icon(Icons.thermostat_outlined),
      path: 'pressure',
      description: 'Ciśnienie atmosferyczne w hPa'),
  WthrConDesc(
      name: "Wilgotność",
      icon: Icon(Icons.device_thermostat_outlined),
      path: 'humidity',
      description: 'Wilgotność w procentach'),
  WthrConDesc(
      name: "Widoczność",
      icon: Icon(Icons.view_agenda_outlined),
      path: 'visibility',
      description: 'Widoczność w metrach'),
  WthrConDesc(
      name: "Prędkość wiatru",
      icon: Icon(Icons.wind_power_outlined),
      path: 'wind-speed',
      description: 'Prędkość wiatru w m/s'),
  WthrConDesc(
      name: "Kierunek wiatru",
      icon: Icon(Icons.wind_power_outlined),
      path: 'wind-direction',
      description: 'Kierunek wiatru w stopniach'),
  WthrConDesc(
      name: "Stęzenie pyłków PM 10",
      icon: Icon(Icons.checklist_rounded),
      path: 'pm10',
      description: 'Stęzenie pyłków PM 10 w µg/m³'),
  WthrConDesc(
      name: "Stęzenie pyłków PM 2.5",
      icon: Icon(Icons.checklist_rounded),
      path: 'pm25',
      description: 'Stęzenie pyłków PM 2.5 w µg/m³'),
];

Map<String, WthrConDesc> wthrConDescMap = {
  'rainfall': wthrConDescList[0],
  'clouds': wthrConDescList[1],
  'temperature': wthrConDescList[2],
  'pressure': wthrConDescList[3],
  'humidity': wthrConDescList[4],
  'visibility': wthrConDescList[5],
  'wind-speed': wthrConDescList[6],
  'wind-direction': wthrConDescList[7],
  'pm10': wthrConDescList[8],
  'pm25': wthrConDescList[9],
};
