// import 'dart:async';
// import 'package:ekomonitor/models/weather-condition-description.dart';

// import 'wthr_con_desc_service.dart';
// import 'package:flutter/material.dart';

// class MockWeatherConditionService implements WthrConDescService {
//   final List<WthrConDesc> _weatherConditions = [
//     const WthrConDesc(
//       name: "Ilość opadów",
//       description: "Ilość opadów w milimetrach",
//       icon: Icon(Icons.umbrella_outlined),
//       path: 'rainfall',
//     ),
//     const WthrConDesc(
//       name: "Pokrycie chmur",
//       description: "Pokrycie chmur w procentach",
//       icon: Icon(Icons.cloud_outlined),
//       path: 'clouds',
//     ),
//     const WthrConDesc(
//       name: "Temperatura",
//       description: "Temperatura w stopniach Celsjusza",
//       icon: Icon(Icons.thermostat_outlined),
//       path: 'temperature',
//     ),
//     const WthrConDesc(
//       name: "Ciśnienie atmosferyczne",
//       description: "Ciśnienie atmosferyczne w hPa",
//       icon: Icon(Icons.speed),
//       path: 'pressure',
//     ),
//     const WthrConDesc(
//       name: "Wilgotność",
//       description: "Wilgotność w procentach",
//       icon: Icon(Icons.water_drop),
//       path: 'humidity',
//     ),
//     const WthrConDesc(
//       name: "Widoczność",
//       description: "Widoczność w metrach",
//       icon: Icon(Icons.visibility),
//       path: 'visibility',
//     ),
//   ];

//   @override
//   Future<List<WthrConDesc>> getWeatherConditions() async {
//     await Future.delayed(const Duration(seconds: 1));
//     return _weatherConditions;
//   }
  
//   @override
//   Future<WthrConDesc> getWeatherCondition(String conditionName) async {
//     await Future.delayed(const Duration(seconds: 1));
//     return _weatherConditions.firstWhere((element) => element.name == conditionName);
//   }
// }