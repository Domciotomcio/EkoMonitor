import 'dart:convert';
import 'dart:developer';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/historical/models/historical_model.dart';
import 'package:http/http.dart' as http;

class HistoricalService {
  // Fetch historical data from the API
  Future<HistoricalModel> getHistoricalData(
      double latitude, double longitude, DateTime start, DateTime end) async {
    log('first start: $start, end: $end');

    final startInt = start.toUtc().millisecondsSinceEpoch ~/ 1000 + 7200;
    final endInt = end.toUtc().millisecondsSinceEpoch ~/ 1000;

    log('start: $startInt, end: $endInt');

    final response = await http.get(Uri.parse(
        '${DATA_PROCESSING_URL}historical/point?lat=51&lon=17&start=${startInt}&end=${endInt}'));

    if (response.statusCode == 200) {
      final responseMap = json.decode(response.body);
      return HistoricalModel.fromJson(responseMap);
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}
