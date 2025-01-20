import 'package:ekomonitor/data/user_profile/providers/user_profile_provider.dart';
import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:ekomonitor/functions/logout_function.dart';
import 'package:ekomonitor/models/weather_condition_description.dart';
import 'package:ekomonitor/models/weather_condition_unit.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:ekomonitor/themes/theme1.dart';
import 'package:ekomonitor/views/developer-view.dart';
import 'package:ekomonitor/views/home/home_view.dart';
import 'package:ekomonitor/views/home/settings_tile.dart';
import 'package:ekomonitor/views/login_view.dart';
import 'package:ekomonitor/views/settings/weather-unit-setting-view.dart';
import 'package:ekomonitor/views/test/user_test_view.dart';
import 'package:ekomonitor/views/weather_forecast_view.dart';
import 'package:ekomonitor/views/weather-unit-view.dart';
import 'package:ekomonitor/widgets/main-tile.dart';
import 'package:ekomonitor/widgets/weather-condition-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/main-tile-dic.dart';

import 'views/form/form_view.dart';
import 'views/settings/app-settings-view.dart';
import 'views/settings/user-settings-view.dart';
import 'views/settings/weather-settings-view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

const MAIN_TILE_CODE = 'default';

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
    text: "Weather settings",
    color: Colors.blue[900]!,
    icon: Icon(Icons.cloud_outlined),
    path: '/weather-settings',
  ),
  const SettingsTileConfig(
    text: "App settings",
    color: Colors.grey,
    icon: Icon(Icons.settings),
    path: '/app-settings',
  ),
  const SettingsTileConfig(
    text: "User settings",
    color: Colors.deepPurple,
    icon: Icon(Icons.person_outline),
    path: '/user-settings',
  ),
];

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      initialRoute: '/home',
      //home: user == null ? LoginView() : HomePage(),
      routes: {
        '/login': (context) => LoginView(),
        '/home': (context) => HomePage(),
        '/weather-settings': (context) => const WeatherSettingsView(),
        '/app-settings': (context) => const AppSettingsView(),
        '/user-settings': (context) => const UserSettingsView(),
        ...generateWeatherSettingsRoutes(wthrConDescList),
        ...generateWeatherRoutes(wthrConDescList),
        '/developer': (context) => DeveloperView(),
        '/form': (context) => FormView(),
        '/user-test': (context) => UserTestView(),
        '/weather-forecast': (context) => WeatherForecastView(),
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
