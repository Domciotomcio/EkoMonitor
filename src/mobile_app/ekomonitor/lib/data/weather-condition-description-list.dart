import 'package:ekomonitor/models/weather_condition_description.dart';
import 'package:flutter/material.dart';

List<WthrConDesc> wthrConDescList = [
  const WthrConDesc(
      name: "Precipitation",
      fixedName: "precipitation",
      icon: Icon(Icons.umbrella_outlined),
      path: 'rainfall',
      description: 'Precipitation in millimeters'),
  const WthrConDesc(
      name: "Precipitation Probability",
      fixedName: "precipitation_probability",
      icon: Icon(Icons.percent_outlined),
      path: 'rainfall_probability',
      description: 'Precipitation probability in percent'),
  const WthrConDesc(
      name: "Cloudiness",
      fixedName: "cloudiness",
      icon: Icon(Icons.cloud),
      path: 'clouds',
      description: 'Cloudiness in percent'),
  const WthrConDesc(
      name: "Temperature",
      fixedName: "temperature",
      icon: Icon(Icons.thermostat_outlined),
      path: 'temperature',
      description: 'Temperature in Celsius'),
  const WthrConDesc(
      name: "Atmospheric Pressure",
      fixedName: "pressure",
      icon: Icon(Icons.speed),
      path: 'pressure',
      description: 'Atmospheric pressure in hPa'),
  const WthrConDesc(
      name: "Humidity",
      fixedName: "humidity",
      icon: Icon(Icons.water_drop),
      path: 'humidity',
      description: 'Humidity in percent'),
  const WthrConDesc(
      name: "Visibility",
      fixedName: "visibility",
      icon: Icon(Icons.visibility),
      path: 'visibility',
      description: 'Visibility in meters'),
  const WthrConDesc(
      name: "Wind Speed",
      fixedName: "wind_speed",
      icon: Icon(Icons.air),
      path: 'wind-speed',
      description: 'Wind speed in m/s'),
  const WthrConDesc(
      name: "Wind Direction",
      fixedName: "wind_direction",
      icon: Icon(Icons.explore),
      path: 'wind-direction',
      description: 'Wind direction in degrees'),
  const WthrConDesc(
      name: "PM 10 Concentration",
      fixedName: "pm10",
      icon: Icon(Icons.filter_drama),
      path: 'pm10',
      description: 'PM 10 concentration in µg/m³'),
  const WthrConDesc(
      name: "PM 2.5 Concentration",
      fixedName: "pm2_5",
      icon: Icon(Icons.filter_drama),
      path: 'pm25',
      description: 'PM 2.5 concentration in µg/m³'),
  const WthrConDesc(
      name: "Air Quality Index (AQI)",
      fixedName: "aqi",
      icon: Icon(Icons.checklist_rounded),
      path: 'pm25',
      description: 'Air Quality Index based on PM 2.5 concentration'),
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
  'pm2_5': wthrConDescList[10],
  'aqi': wthrConDescList[11],
};
