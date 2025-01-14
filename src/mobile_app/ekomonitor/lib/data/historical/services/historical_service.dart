
import 'dart:convert';

import 'package:ekomonitor/data/historical/models/historical_model.dart';
import 'package:http/http.dart' as http;

class HistoricalService {
  // Fetch historical data from the API
  Future<HistoricalModel> getHistoricalData(double latitude, double longitude, int start, int end) async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8001/historical/point?lat=51&lon=17&start=1736768282&end=1736768282'));

    if (response.statusCode == 200) {
      final responseMap = json.decode(response.body);
      return HistoricalModel.fromJson(responseMap);
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}