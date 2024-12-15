import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:ekomonitor/views/settings/weather-unit-setting-view.dart';
import 'package:ekomonitor/widgets/main-tile.dart';
import 'package:ekomonitor/widgets/weather-condition-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/main-tile-dic.dart';

import 'views/settings/app-settings-view.dart';
import 'views/settings/user-settings-view.dart';
import 'views/settings/weather-settings-view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final ThemeData theme1 = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 173, 52, 52),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);

final ThemeData theme2 = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 82, 68, 183),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);

final ThemeData theme3 = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 52, 173, 52),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(theme1);

  void setTheme(ThemeData theme) {
    state = theme;
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

const MAIN_TILE_CODE = 'rainy';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
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

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Witaj Developerze'),
        actions: [
          IconButton.filled(onPressed: () {}, icon: Icon(Icons.person)),
          IconButton.filled(
              onPressed: () {
                print("Bla bla bla");
              },
              icon: Icon(Icons.brightness_4)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Witaj w aplikacji Ekomonitor"),
              MainTile(),
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
              FilledButton(
                  onPressed: () {
                    Color mainColor = Colors.amber;

                    ref
                        .read(weatherStatusNotifierProvider.notifier)
                        .updateWeatherStatus(
                          WeatherStatus(
                              mainTileConfig: mainTileDict['sunny']!,
                              wthrConUnitList: wthrConUnitList,
                              theme: ThemeData(
                                colorScheme: ColorScheme.fromSeed(
                                  seedColor: mainColor,
                                  brightness: Brightness.light,
                                ),
                                useMaterial3: true,
                              )),
                        );
                  },
                  child: Text("Opcja 1 - słonecznie")),
              FilledButton(
                onPressed: () {
                  Color mainColor = Colors.blue;

                  ref
                      .read(weatherStatusNotifierProvider.notifier)
                      .updateWeatherStatus(WeatherStatus(
                        mainTileConfig: MainTileConfig(
                            code: 'rainy',
                            color: mainColor,
                            title: 'Dzisiaj pochmurno i deszczowo',
                            subtitle: 'Prognozowane opady',
                            icon: Icons.cloudy_snowing),
                        wthrConUnitList: wthrConUnitList,
                        theme: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: mainColor,
                            brightness: Brightness.light,
                          ),
                          useMaterial3: true,
                        ),
                      ));
                },
                child: Text("Opcja 2 - deszczowo"),
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

////////////////////////
class WeatherStatus {
  final MainTileConfig mainTileConfig;
  final List<WthrConUnit> wthrConUnitList;
  final ThemeData theme;

  WeatherStatus({
    required this.mainTileConfig,
    required this.wthrConUnitList,
    required this.theme,
  });
}

class WeatherStatusNotifier extends StateNotifier<WeatherStatus> {
  final Ref ref;

  WeatherStatusNotifier(this.ref)
      : super(WeatherStatus(
          mainTileConfig: mainTileDict[MAIN_TILE_CODE]!,
          wthrConUnitList: wthrConUnitList,
          theme: theme1,
        ));

  void updateWeatherStatus(WeatherStatus weatherStatus) {
    state = weatherStatus;
    // Update the theme using ThemeNotifier
    ref.read(themeNotifierProvider.notifier).setTheme(weatherStatus.theme);
  }
}

final weatherStatusNotifierProvider =
    StateNotifierProvider<WeatherStatusNotifier, WeatherStatus>((ref) {
  return WeatherStatusNotifier(ref);
});
