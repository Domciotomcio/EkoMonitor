import 'package:ekomonitor/data/forecast/services/forecast_service.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekomonitor/data/forecast/models/forecast_model.dart';
import 'package:intl/intl.dart';

class WeatherForecastView extends ConsumerStatefulWidget {
  @override
  _WeatherForecastViewState createState() => _WeatherForecastViewState();
}

class _WeatherForecastViewState extends ConsumerState<WeatherForecastView> {
  final ForecastService forecastService = ForecastService();
  DateTime time = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: FutureBuilder<ForecastModel>(
          future: forecastService.fetchForecast(51, 17, time),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              final forecast = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    FilledButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text(
                            "Forcast for ${DateFormat('yyyy-MM-dd').format(time)}")),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.umbrella_outlined,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Precipitation'),
                      subtitle: Text(
                          '${forecast.precipitation.toStringAsFixed(2)} mm'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.percent_outlined,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Precipitation Probability'),
                      subtitle: Text(
                          '${forecast.precipitationProbability.toStringAsFixed(2)} %'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.wb_cloudy,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Cloudiness'),
                      subtitle:
                          Text('${forecast.cloudiness.toStringAsFixed(2)} %'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.thermostat_outlined,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Temperature'),
                      subtitle:
                          Text('${forecast.temperature.toStringAsFixed(2)} °C'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.speed,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Pressure'),
                      subtitle:
                          Text('${forecast.pressure.toStringAsFixed(2)} hPa'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.water_drop,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Humidity'),
                      subtitle:
                          Text('${forecast.humidity.toStringAsFixed(2)} %'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.visibility,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Visibility'),
                      subtitle:
                          Text('${forecast.visibility.toStringAsFixed(2)} km'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.air,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Wind Speed'),
                      subtitle:
                          Text('${forecast.windSpeed.toStringAsFixed(2)} m/s'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.explore,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('Wind Degrees'),
                      subtitle:
                          Text('${forecast.windDegrees.toStringAsFixed(2)} °'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.filter_drama,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('PM10'),
                      subtitle:
                          Text('${forecast.pm10.toStringAsFixed(2)} µg/m³'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.filter_drama_outlined,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('PM2.5'),
                      subtitle:
                          Text('${forecast.pm25.toStringAsFixed(2)} µg/m³'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.checklist,
                          color: ref.watch(themeProvider).primaryColor),
                      title: Text('AQI'),
                      subtitle: Text('${forecast.aqi.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
