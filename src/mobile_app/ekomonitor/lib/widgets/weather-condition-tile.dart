import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:flutter/material.dart';

class WeatherConditionTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Icon(wthrConUnit.wthrConDesc.icon.icon, size: 32),
              top: 8,
              right: 8,
            ),
            Positioned(
              child: Text(wthrConUnit.wthrConDesc.name),
              bottom: 8,
              right: 8,
            ),
            Positioned(
              child: Text(wthrConUnit.value, style: TextStyle(fontSize: 24)),
              bottom: 8,
              left: 8,
            ),
          ],
        ));
  }
}
