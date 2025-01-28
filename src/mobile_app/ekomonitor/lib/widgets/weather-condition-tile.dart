import 'dart:developer';

import 'package:ekomonitor/main.dart';
import 'package:ekomonitor/models/weather_condition_description.dart';
import 'package:ekomonitor/models/weather_condition_unit.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:ekomonitor/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherConditionTile extends ConsumerWidget {
  final WthrConUnit wthrConUnit;

  const WeatherConditionTile(
      {Key? key,
      this.wthrConUnit = const WthrConUnit(
        wthrConDesc: const WthrConDesc(
          name: 'name',
          fixedName: 'fixedName',
          unit: 'unit',
          description: 'description',
          icon: Icon(Icons.ac_unit),
          path: 'path',
        ),
        value: 'value',
      )})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log(wthrConUnit.value);
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: ref.watch(themeProvider).primaryColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(wthrConUnit.wthrConDesc.icon.icon,
                  size: 32, color: ref.watch(themeProvider).primaryColor),
              SizedBox(height: 8),
              Expanded(
                  child: Text(
                      "${wthrConUnit.value} ${wthrConUnit.wthrConDesc.unit}",
                      style: TextStyle(fontSize: 20))),
              Expanded(
                child: Text(
                  wthrConUnit.wthrConDesc.name,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ));
  }
}
