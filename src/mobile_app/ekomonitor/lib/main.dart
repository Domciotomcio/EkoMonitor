import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:ekomonitor/views/settings/weather-unit-setting-view.dart';
import 'package:ekomonitor/widgets/weather-condition-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/settings/app-settings-view.dart';
import 'views/settings/user-settings-view.dart';
import 'views/settings/weather-settings-view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final List<WthrConUnit> wthrConUnitList = [
  WthrConUnit(
    wthrConDesc: wthrConDescList[0],
    value: 'value',
  ),
  WthrConUnit(
    wthrConDesc: wthrConDescList[1],
    value: 'value',
  ),
  WthrConUnit(
    wthrConDesc: wthrConDescList[2],
    value: 'value',
  ),
  WthrConUnit(
    wthrConDesc: wthrConDescList[3],
    value: 'value',
  ),
];

final List<SettingsButtonConfig> settingsList = [
  SettingsButtonConfig(
    text: "Ustawienia pogody",
    color: Colors.blue[900]!,
    icon: Icon(Icons.cloud_outlined),
    path: '/weather-settings',
  ),
  const SettingsButtonConfig(
    text: "Ustawienia aplikacji",
    color: Colors.grey,
    icon: Icon(Icons.settings),
    path: '/app-settings',
  ),
  const SettingsButtonConfig(
    text: "Ustawienia uzytkownika",
    color: Colors.deepPurple,
    icon: Icon(Icons.person_outline),
    path: '/user-settings',
  ),
];

class MainTile extends StatelessWidget {
  final String subtitle;
  final String title;
  final Color color;
  final IconData icon;

  const MainTile({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
          width: double.infinity,
          height: 130,
          child: Stack(
            children: <Widget>[
              Container(
                color: color,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subtitle),
                      Text(title,
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  left: 8,
                  bottom: 8),
              const Positioned(
                  child: Icon(
                    Icons.abc,
                    size: 64,
                  ),
                  right: 8,
                  top: 8),
            ],
          )),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/weather-settings': (context) => const WeatherSettingsView(),
        '/app-settings': (context) => const AppSettingsView(),
        '/user-settings': (context) => const UserSettingsView(),
        ...generateWeatherSettingsRoutes(wthrConDescList),
        ...generateWeatherRoutes(wthrConDescList),
      },
    );
  }
}

Map<String, WidgetBuilder> generateWeatherSettingsRoutes(
    List<WthrConDesc> weatherUnits) {
  return Map.fromEntries(
    weatherUnits.map((weatherUnit) {
      return MapEntry(
        weatherUnit.settingsPath,
        (context) => WeatherUnitSettingView(weatherCondition: weatherUnit),
      );
    }),
  );
}

Map<String, WidgetBuilder> generateWeatherRoutes(
    List<WthrConDesc> weatherUnits) {
  return Map.fromEntries(
    weatherUnits.map((weatherUnit) {
      return MapEntry(
        weatherUnit.path,
        (context) => WeatherUnitSettingView(weatherCondition: weatherUnit),
      );
    }),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Witaj Developerze'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Witaj w aplikacji Ekomonitor"),
              const MainTile(
                color: Colors.red,
                title: 'Tytuł',
                subtitle: 'Podtytuł',
                icon: Icons.ac_unit,
              ),
              const Divider(),
              const Text("Warunki pogodowe"),
              const WeatherCarousel(),
              const Divider(),
              const Text("Warto zwrócić na to uwagę"),
              const ListTile(
                title: Text("Tytuł"),
                subtitle: Text("Podtytuł"),
                leading: Icon(Icons.ac_unit),
              ),
              const ListTile(
                title: Text("Tytuł"),
                subtitle: Text("Podtytuł"),
                leading: Icon(Icons.ac_unit),
              ),
              const ListTile(
                title: Text("Tytuł"),
                subtitle: Text("Podtytuł"),
                leading: Icon(Icons.ac_unit),
              ),
              const Divider(),
              const Text("Ustawienia"),
              Row(
                children: settingsList
                    .map((config) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0), // Add horizontal padding
                            child: SettingsButton(config: config),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherCarousel extends StatelessWidget {
  const WeatherCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 130,
        child: CarouselView(
          scrollDirection: Axis.horizontal,
          itemExtent: 240,
          children: wthrConUnitList
              .map((wthrConUnit) =>
                  WeatherConditionTile(wthrConUnit: wthrConUnit))
              .toList(),
        ));
  }
}

// SETTINGS BUTTON

class SettingsButtonConfig {
  final String text;
  final Color color;
  final Icon icon;
  final String path;

  const SettingsButtonConfig(
      {this.text = "Ustawienia",
      this.color = Colors.grey,
      this.icon = const Icon(Icons.settings),
      this.path = "/"});
}

class SettingsButton extends StatelessWidget {
  final SettingsButtonConfig config;

  const SettingsButton({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, config.path),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: config.color),
        ),
        height: 100,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              child: Icon(
                config.icon.icon,
                color: config.color,
                size: 32,
              ),
              right: 8,
              top: 8,
            ),
            Positioned(
              child: Text(
                config.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              left: 8,
              bottom: 8,
            ),
          ],
        ),
      ),
    );
  }
}
