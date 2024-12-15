import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final List<SettingsButtonConfig> settingsList = [
  const SettingsButtonConfig(
    text: "Ustawienia pogody",
    color: Colors.blueGrey,
    icon: Icon(Icons.settings),
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
    icon: Icon(Icons.settings),
    path: '/user-settings',
  ),
];

class WeatherSettingsView extends StatelessWidget {
  const WeatherSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia pogody'),
      ),
      body: ListView(
        children: [
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
        ],
      ),
    );
  }
}

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
      },
    );
  }
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
                    .map((config) =>
                        Expanded(child: SettingsButton(config: config)))
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
    return const SizedBox(
      height: 130,
      child: CarouselView(
          scrollDirection: Axis.horizontal,
          itemExtent: double.infinity,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Placeholder(),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Placeholder(),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Placeholder(),
            ),
          ]),
    );
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
              child: config.icon,
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
