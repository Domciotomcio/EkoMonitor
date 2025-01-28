import 'dart:developer';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/historical/models/historical_model.dart';
import 'package:ekomonitor/data/historical/services/historical_service.dart';
import 'package:ekomonitor/data/measurement/models/measurement_model.dart';
import 'package:ekomonitor/models/weather_condition_description.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUnitView extends StatefulWidget {
  final WthrConDesc weatherCondition;

  WeatherUnitView({
    super.key,
    required this.weatherCondition,
  });

  @override
  State<WeatherUnitView> createState() => _WeatherUnitViewState();
}

class _WeatherUnitViewState extends State<WeatherUnitView> {
  final HistoricalService historicalService = HistoricalService();

  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.weatherCondition.name),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.weatherCondition.icon.icon, size: 100),
              Text(widget.weatherCondition.name),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: FilledButton(
                            onPressed: () => _selectDate(context, true),
                            child: Text(
                                "From ${DateFormat('yyyy-MM-dd').format(startDate)}"))),
                    const SizedBox(width: 16),
                    Expanded(
                        child: FilledButton(
                            onPressed: () => _selectDate(context, false),
                            child: Text(
                                "To ${DateFormat('yyyy-MM-dd').format(endDate)}"))),
                  ],
                ),
              ),
              FutureBuilder(
                  future: historicalService.getHistoricalData(
                    LATITUDE,
                    LONGITUDE,
                    startDate,
                    endDate,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      HistoricalModel historicalModel =
                          snapshot.data as HistoricalModel;
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children:
                            historicalModel.weatherData.entries.map((entry) {
                          final int date = int.parse(entry.key) + 86400;
                          final measurement = entry.value[widget
                              .weatherCondition
                              .fixedName]!; // Assuming 'weatherCondition.name' is the correct field
                          final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  1000 * date));

                          return ListTile(
                            leading: Icon(widget.weatherCondition.icon.icon),
                            title: Text(
                                "${measurement.value.toStringAsFixed(1)} ${measurement.unit}"),
                            subtitle: Text(formattedDate),
                          );
                        }).toList(),
                      );
                    } else {
                      return const Text('No data available');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
