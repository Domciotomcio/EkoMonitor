import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:flutter/material.dart';

const List<WthrConDesc> wthrConDescList = [
  WthrConDesc(
      name: "Ilość opadów",
      icon: Icon(Icons.ac_unit),
      path: 'rainfall',
      description: 'Ilość opadów w milimetrach'),
  WthrConDesc(
      name: "Pokrycie chmur",
      icon: Icon(Icons.ac_unit),
      path: 'clouds',
      description: 'Pokrycie chmur w procentach'),
  WthrConDesc(
      name: "Temperatura",
      icon: Icon(Icons.ac_unit),
      path: 'temperature',
      description: 'Temperatura w stopniach Celsjusza'),
  WthrConDesc(
      name: "Ciśnienie atmosferyczne",
      icon: Icon(Icons.ac_unit),
      path: 'pressure',
      description: 'Ciśnienie atmosferyczne w hPa'),
  WthrConDesc(
      name: "Wilgotność",
      icon: Icon(Icons.ac_unit),
      path: 'humidity',
      description: 'Wilgotność w procentach'),
  WthrConDesc(
      name: "Widoczność",
      icon: Icon(Icons.ac_unit),
      path: 'visibility',
      description: 'Widoczność w metrach'),
  WthrConDesc(
      name: "Prędkość wiatru",
      icon: Icon(Icons.ac_unit),
      path: 'wind-speed',
      description: 'Prędkość wiatru w m/s'),
  WthrConDesc(
      name: "Kierunek wiatru",
      icon: Icon(Icons.ac_unit),
      path: 'wind-direction',
      description: 'Kierunek wiatru w stopniach'),
  WthrConDesc(
      name: "Stęzenie pyłków PM 10",
      icon: Icon(Icons.ac_unit),
      path: 'pm10',
      description: 'Stęzenie pyłków PM 10 w µg/m³'),
  WthrConDesc(
      name: "Stęzenie pyłków PM 2.5",
      icon: Icon(Icons.ac_unit),
      path: 'pm25',
      description: 'Stęzenie pyłków PM 2.5 w µg/m³'),
];
