import 'package:ekomonitor/data/hourly/providers/hourly_provider.dart';
import 'package:ekomonitor/data/main-tile-dic.dart';
import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:ekomonitor/functions/logout_function.dart';
import 'package:ekomonitor/main.dart';
import 'package:ekomonitor/models/weather_condition_unit.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:ekomonitor/themes/theme1.dart';
import 'package:ekomonitor/views/home/settings_tile.dart';
import 'package:ekomonitor/widgets/main-tile.dart';
import 'package:ekomonitor/widgets/weather-condition-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: ref.watch(userProvider) != null
            ? Text('Welcome ${ref.watch(userProvider)!.firstName}')
            : const Text('Welcome in Ekomonitor'),
        actions: [
          // user logged
          if (ref.watch(userProvider) != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => logoutFunction(context, ref),
            ),
          if (ref.watch(userProvider) == null)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),

          // IconButton(
          //   icon: const Icon(Icons.warning),
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/developer');
          //   },
          // ),
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
            const Text("Weather conditions"),
            SizedBox(height: 120, child: const WeatherCarousel()),
            const Divider(),
            WorthMentioning(),
            const Divider(),
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/weather-forecast'),
              leading: Icon(Icons.wb_sunny_outlined,
                  color: ref.watch(themeProvider).primaryColor),
              title: Text("Weather forecast"),
            ),
            const Divider(),
            const Text("Settings"),
            IntrinsicHeight(
              child: Row(
                children: settingsList
                    .map((config) =>
                        Expanded(child: SettingsTile(config: config)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorthMentioning extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("See the details of the weather conditions"),
        for (int i = 0; i < 3; i++)
          ListTile(
            title: Text(wthrConDescList[i].name),
            subtitle: Text(wthrConDescList[i].description),
            leading: Icon(wthrConDescList[i].icon.icon,
                color: ref.watch(themeProvider).primaryColor),
            onTap: () {
              print("Tapped on ${wthrConDescList[i].name}");
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
            const Text("Settings"),
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
    final hourlyWeather = ref.watch(hourlyProvider);

    if (hourlyWeather == null) {
      return Container(
          width: double.infinity,
          child: Center(child: const CircularProgressIndicator()));
    }

    return CarouselView(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      scrollDirection: Axis.horizontal,
      itemExtent: 200,
      onTap: (value) =>
          Navigator.pushNamed(context, wthrConDescList[value].path),
      children: ref
          .watch(hourlyProvider)!
          .weatherConditions
          .entries
          .map((entry) => WeatherConditionTile(
                wthrConUnit: WthrConUnit(
                  wthrConDesc: wthrConDescMap[entry.key]!,
                  value: entry.value.value.toString() + " " + entry.value.unit,
                ),
              ))
          .toList(),
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
    ref.read(themeProvider.notifier).setTheme(weatherStatus.theme);
  }
}

final weatherStatusNotifierProvider =
    StateNotifierProvider<WeatherStatusNotifier, WeatherStatus>((ref) {
  return WeatherStatusNotifier(ref);
});
