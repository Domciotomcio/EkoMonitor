import 'dart:developer';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/models/weather-condition-unit.dart';
import 'package:http/http.dart' as http;
import 'package:ekomonitor/services/wthr_con_unit/wthr_con_unit_service.dart';

class ApiWthrConUnitService implements WthrConUnitService {
  @override
  Future<WthrConUnit> getWthrConUnit(String unitName) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/api/weather-condition-unit/$unitName')); // TODO: Change this to the actual endpoint of the API

    if (response.statusCode == 200) {
      return WthrConUnit.fromJson(response.body as Map<String, dynamic>);
    } else {
      log('Failed to load weather condition unit');
      throw Exception('Failed to load weather condition unit');
    }
  }
}
