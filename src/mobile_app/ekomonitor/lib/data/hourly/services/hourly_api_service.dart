import 'dart:convert';

import 'package:ekomonitor/data/hourly/models/hourly_model.dart';
import 'package:ekomonitor/data/hourly/services/hourly_service.dart';
import 'package:http/http.dart' as http;

class HourlyApiService implements HourlyService {
  @override
  Future<HourlyModel> getHourlyData(double latitude, double longitude) async {
    final response = await http.get(
        Uri.parse('http://localhost:8001/hourly?lat=$latitude&lon=$longitude'));

    if (response.statusCode == 200) {
      final responseMap = json.decode(response.body);
      responseMap['weather_conditions']!.remove('pollen');

      return HourlyModel.fromJson(responseMap);
    } else {
      throw Exception('Failed to load hourly data');
    }
  }
}
