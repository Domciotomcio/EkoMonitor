import 'package:ekomonitor/models/weather-condition-description.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:ekomonitor/services/wthr_con_unit/wthr_con_unit_service.dart';
import 'package:flutter/material.dart';

class MockWthrConUnitService implements WthrConUnitService {
  @override
  Future<WthrConUnit> getWthrConUnit(String unitName) async {
    return WthrConUnit(
      wthrConDesc: WthrConDesc(
        name: 'mock name',
        fixedName: 'mock fixedName',
        description: 'mock description',
        icon: Icon(Icons.ice_skating_outlined),
        path: '',
      ),
      value: 'mock value',
    );
  }
}
