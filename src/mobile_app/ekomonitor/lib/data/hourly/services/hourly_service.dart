import 'package:ekomonitor/data/hourly/models/hourly_model.dart';

abstract class HourlyService {
  Future<HourlyModel> getHourlyData(double latitude, double longitude);
}
