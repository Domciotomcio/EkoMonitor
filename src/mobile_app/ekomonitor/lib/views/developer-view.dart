import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:ekomonitor/main.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:ekomonitor/widgets/main-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeveloperView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developer View'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Welcome to the Developer View!'),
            SizedBox(height: 64),
            FilledButton(
              onPressed: () {
                Color mainColor = Colors.yellow[100]!;
                ThemeData theme = ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: mainColor,
                    brightness: Brightness.light,
                  ),
                  useMaterial3: true,
                );
                ref
                    .read(weatherStatusNotifierProvider.notifier)
                    .updateWeatherStatus(
                      WeatherStatus(
                          mainTileConfig: MainTileConfig(
                              code: 'sunny',
                              color: theme.colorScheme.primary,
                              title: 'Dzisiaj piękny dzień na spacer',
                              subtitle: 'Słonecznie',
                              icon: Icons.wb_sunny_outlined),
                          wthrConUnitList: [
                            WthrConUnit(
                                wthrConDesc: wthrConDescMap['temperature']!,
                                value: '25°C'),
                            WthrConUnit(
                                wthrConDesc: wthrConDescMap['humidity']!,
                                value: '50%'),
                            WthrConUnit(
                                wthrConDesc: wthrConDescMap['wind-speed']!,
                                value: '5 km/h'),
                          ],
                          theme: theme),
                    );
              },
              child: Text("Opcja 1 - słonecznie"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
            ),
            SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Color mainColor = Colors.blue;
                ThemeData theme = ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: mainColor,
                    brightness: Brightness.light,
                  ),
                  useMaterial3: true,
                );

                ref
                    .read(weatherStatusNotifierProvider.notifier)
                    .updateWeatherStatus(WeatherStatus(
                      mainTileConfig: MainTileConfig(
                          code: 'rainy',
                          color: theme.colorScheme.primary,
                          title: 'Dzisiaj pochmurno i deszczowo',
                          subtitle: 'Prognozowane opady',
                          icon: Icons.cloudy_snowing),
                      wthrConUnitList: [
                        WthrConUnit(
                            wthrConDesc: wthrConDescMap['temperature']!,
                            value: '15°C'),
                        WthrConUnit(
                            wthrConDesc: wthrConDescMap['humidity']!,
                            value: '80%'),
                        WthrConUnit(
                            wthrConDesc: wthrConDescMap['wind-speed']!,
                            value: '8 m/s'),
                        WthrConUnit(
                            wthrConDesc: wthrConDescMap['wind-direction']!,
                            value: 'WE'),
                        WthrConUnit(
                            wthrConDesc: wthrConDescMap['pm10']!,
                            value: '2,3 µg'),
                      ],
                      theme: theme,
                    ));
              },
              child: Text("Opcja 2 - deszczowo"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
