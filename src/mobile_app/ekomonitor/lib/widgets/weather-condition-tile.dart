import 'package:ekomonitor/main.dart';
import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherConditionTile extends ConsumerWidget {
  final WthrConUnit wthrConUnit;

  const WeatherConditionTile(
      {Key? key,
      this.wthrConUnit = const WthrConUnit(
        wthrConDesc: const WthrConDesc(
          name: 'name',
          description: 'description',
          icon: Icon(Icons.ac_unit),
          path: 'path',
        ),
        value: 'value',
      )})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color:
                  ref.watch(weatherStatusNotifierProvider).theme.primaryColor,
              width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(wthrConUnit.wthrConDesc.icon.icon,
                      size: 32,
                      color: ref
                          .watch(weatherStatusNotifierProvider)
                          .theme
                          .primaryColor),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: Text(wthrConUnit.value,
                          style: TextStyle(fontSize: 20))),
                  Expanded(
                    child: Text(
                      wthrConUnit.wthrConDesc.name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
