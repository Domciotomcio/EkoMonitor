import 'dart:developer';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/historical/models/historical_model.dart';
import 'package:ekomonitor/data/historical/services/historical_service.dart';
import 'package:ekomonitor/data/measurement/models/measurement_model.dart';
import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUnitView extends StatelessWidget {
  final WthrConDesc weatherCondition;
  final HistoricalService historicalService = HistoricalService();

  WeatherUnitView({
    super.key,
    required this.weatherCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherCondition.name),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(weatherCondition.icon.icon, size: 100),
              Text(weatherCondition.name),
              SizedBox(height: 16),
              FutureBuilder(
                  future: historicalService.getHistoricalData(
                      LATITUDE, LONGITUDE, 1736768282, 1736768282),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      HistoricalModel historicalModel =
                          snapshot.data as HistoricalModel;
                      return ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children:
                            historicalModel.weatherData.entries.map((entry) {
                          final int date = int.parse(entry.key);
                          final measurement = entry.value[weatherCondition
                              .fixedName]!; // Assuming 'weatherCondition.name' is the correct field
                          final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  1000 * date));
                          return ListTile(
                            title: Text(measurement.value.toString() +
                                " " +
                                measurement.unit),
                            trailing: Text(formattedDate),
                          );
                        }).toList(),
                      );
                    } else {
                      return Text('No data available');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
