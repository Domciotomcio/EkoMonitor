import 'package:ekomonitor/widgets/main-tile.dart';
import 'package:flutter/material.dart';

// const Map<String, MainTile> mainTileDict = {
//   'sunny': MainTile(
//     color: Colors.amber,
//     title: 'Dzisiaj piękny dzień na spacer',
//     subtitle: 'Słonecznie',
//     icon: Icons.wb_sunny_outlined,
//   ),
//   'rainy': MainTile(
//     color: Colors.blue,
//     title: 'Dzisiaj pochmurno i deszczowo',
//     subtitle: 'Prognozowane opady',
//     icon: Icons.cloudy_snowing,
//   ),
//   'strong-wind': MainTile(
//     color: Colors.orange,
//     title: 'Silny wiatr, zostań w domu!',
//     subtitle: 'Bardzo silny wiatr',
//     icon: Icons.wind_power_outlined,
//   ),
// };

const Map<String, MainTileConfig> mainTileDict = {
  'sunny': MainTileConfig(
    color: Colors.amber,
    title: 'Dzisiaj piękny dzień na spacer',
    subtitle: 'Słonecznie',
    icon: Icons.wb_sunny_outlined,
    code: 'sunny',
  ),
  'rainy': MainTileConfig(
    color: Colors.blue,
    title: 'Dzisiaj pochmurno i deszczowo',
    subtitle: 'Prognozowane opady',
    icon: Icons.cloudy_snowing,
    code: 'rainy',
  ),
  'strong-wind': MainTileConfig(
    color: Colors.orange,
    title: 'Silny wiatr, zostań w domu!',
    subtitle: 'Bardzo silny wiatr',
    icon: Icons.wind_power_outlined,
    code: 'strong-wind',
  ),
};
