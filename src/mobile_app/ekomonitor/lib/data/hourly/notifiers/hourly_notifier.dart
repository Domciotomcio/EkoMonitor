import 'dart:developer';

import 'package:ekomonitor/data/hourly/models/hourly_model.dart';
import 'package:ekomonitor/data/hourly/services/hourly_service.dart';
import 'package:ekomonitor/data/weather-condition-description-list.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HourlyNotifier extends StateNotifier<HourlyModel?> {
  final HourlyService _service;
  final Ref ref;

  HourlyNotifier(this._service, this.ref) : super(null);

  Future<void> fetchHourly(double latitude, double longitude) async {
    state = await _service.getHourlyData(latitude, longitude);
    log("Hourly data fetched, state: ${state!}");
  }

  List<WthrConUnit> getLatestHourlyData() {
    var myList = <WthrConUnit>[];


    // for elements in state!.weatherConditions
    state!.weatherConditions.forEach((key, value) {
      myList.add(WthrConUnit(
        wthrConDesc: wthrConDescMap[key]!,
        value: value.value.toString(),
      ));
    });

    return myList;
  }
}