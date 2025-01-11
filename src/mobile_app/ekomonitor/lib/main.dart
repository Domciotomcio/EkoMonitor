import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:ekomonitor/views/developer-view.dart';
import 'package:ekomonitor/views/settings/weather-unit-setting-view.dart';
import 'package:ekomonitor/views/weather-unit-view.dart';
import 'package:ekomonitor/widgets/main-tile.dart';
import 'package:ekomonitor/widgets/weather-condition-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/main-tile-dic.dart';

import 'views/form/form-view.dart';
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

final List<SettingsTileConfig> settingsList = [
  SettingsTileConfig(
    text: "Ustawienia pogody",
    color: Colors.blue[900]!,
    icon: Icon(Icons.cloud_outlined),
    path: '/weather-settings',
  ),
  const SettingsTileConfig(
    text: "Ustawienia aplikacji",
    color: Colors.grey,
    icon: Icon(Icons.settings),
    path: '/app-settings',
  ),
  const SettingsTileConfig(
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
      initialRoute: '/form',
      routes: {
        '/': (context) => HomePage(),
        '/weather-settings': (context) => const WeatherSettingsView(),
        '/app-settings': (context) => const AppSettingsView(),
        '/user-settings': (context) => const UserSettingsView(),
        ...generateWeatherSettingsRoutes(wthrConDescList),
        ...generateWeatherRoutes(wthrConDescList),
        '/developer': (context) => DeveloperView(),
        '/form': (context) => FormView(),
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
        (context) => WeatherUnitView(weatherCondition: weatherUnit),
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
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: () {
              Navigator.pushNamed(context, '/developer');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const HomeViewMobile();
          } else {
            return const HomeViewDesktop();
          }
        },
      ),
    );
  }
}

class HomeViewMobile extends ConsumerWidget {
  const HomeViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainTile(),
            const Divider(),
            const Text("Warunki pogodowe"),
            SizedBox(height: 100, child: const WeatherCarousel()),
            const Divider(),
            WorthMentioning(),
            const Divider(),
            const Text("Ustawienia"),
            Row(
              children: settingsList
                  .map((config) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0), // Add horizontal padding
                          child: SettingsTile(config: config),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class WorthMentioning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Warto zwrócić na to uwagę"),
        for (int i = 0; i < 3; i++)
          ListTile(
            title: Text(wthrConDescList[i].name),
            subtitle: Text(wthrConDescList[i].description),
            leading: Icon(wthrConDescList[i].icon.icon),
            onTap: () {
              Navigator.pushNamed(context, wthrConDescList[i].path);
            },
          ),
      ],
    );
  }
}

class HomeViewDesktop extends ConsumerWidget {
  const HomeViewDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainTile(),
            const Divider(),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 200,
                      child: Column(
                        children: ref
                            .watch(weatherStatusNotifierProvider)
                            .wthrConUnitList
                            .map((wthrConUnit) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom:
                                          8.0), // Add space between the widgets
                                  child: WeatherConditionTile(
                                      wthrConUnit: wthrConUnit),
                                ))
                            .toList(),
                      )),
                  SizedBox(width: 8), // Add space between the two columns
                  Expanded(
                      child: Container(
                          height: 400,
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Center(child: Text("Presentation")))),
                ],
              ),
            ),
            const Divider(),
            WorthMentioning(),
            const Divider(),
            const Text("Ustawienia"),
            Row(
              children: settingsList
                  .map((config) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0), // Add horizontal padding
                          child: SettingsTile(config: config),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherCarousel extends ConsumerWidget {
  const WeatherCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CarouselView(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      scrollDirection: Axis.horizontal,
      itemExtent: 200,
      children: ref
          .watch(weatherStatusNotifierProvider)
          .wthrConUnitList
          .map((wthrConUnit) => WeatherConditionTile(wthrConUnit: wthrConUnit))
          .toList(),
    );
  }
}

// SETTINGS BUTTON

class SettingsTileConfig {
  final String text;
  final Color color;
  final Icon icon;
  final String path;

  const SettingsTileConfig(
      {this.text = "Ustawienia",
      this.color = Colors.grey,
      this.icon = const Icon(Icons.settings),
      this.path = "/"});
}

class SettingsTile extends StatelessWidget {
  final SettingsTileConfig config;

  const SettingsTile({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, config.path),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: config.color),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    config.icon.icon,
                    color: config.color,
                    size: 32,
                  ),
                ],
              ),
              Text(
                config.text,
              ),
            ],
          ),
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
