import 'package:ekomonitor/models/weather_condition_description.dart';
import 'package:ekomonitor/models/weather_condition_unit.dart';
import 'package:ekomonitor/services/wthr_con_unit/wthr_con_unit_service.dart';
import 'package:flutter/material.dart';

class MockWthrConUnitService implements WthrConUnitService {
  @override
  Future<WthrConUnit> getWthrConUnit(String unitName) async {
    return WthrConUnit(
      wthrConDesc: WthrConDesc(
        name: 'mock name',
        fixedName: 'mock fixedName',
        unit: 'mock unit',
        description: 'mock description',
        icon: Icon(Icons.ice_skating_outlined),
        path: '',
      ),
      value: 'mock value',
    );
  }
}
