import 'dart:convert';
import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/forecast/models/forecast_model.dart';
import 'package:http/http.dart' as http;

class ForecastService {
  // A method to fetch JSON data (e.g., from assets or an API)
  Future<ForecastModel> fetchForecast(
      double latitude, double longitude, DateTime time) async {
    try {
      final timeUnix = time.toUtc().millisecondsSinceEpoch ~/ 1000;

      final response = await http.get(Uri.parse(
          '${AI_FORECASTING_URL}forecast?code=${FORECAST_CODE}&timestamp=${timeUnix}&lat=${latitude}&lon=${longitude}'));

      if (response.statusCode == 200) {
        // Decode JSON
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final flattenedData = flattenJson(jsonData);

        // Convert to ForecastModel object
        return ForecastModel.fromJson(flattenedData);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      throw Exception('Failed to load weather data: $e');
    }
  }
}

Map<String, dynamic> flattenJson(Map<String, dynamic> jsonData) {
  final Map<String, dynamic> flattenedData = {};

  jsonData.forEach((key, value) {
    if (value is Map && value.containsKey("0")) {
      // If the value is a Map and contains a key "0", extract its value
      flattenedData[key] = value["0"];
    } else {
      // Otherwise, keep the original structure
      flattenedData[key] = value;
    }
  });

  return flattenedData;
}
