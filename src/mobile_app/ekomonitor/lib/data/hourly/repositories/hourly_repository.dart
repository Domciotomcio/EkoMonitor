import 'package:ekomonitor/data/hourly/models/hourly_model.dart';
import 'package:ekomonitor/data/hourly/services/hourly_service.dart';

class HourlyRepository {
  final HourlyService _service;

  HourlyRepository(this._service);

  Future<HourlyModel> getHourly(double latitude, double longitude) async {
    return await _service.getHourlyData(latitude, longitude);
  }
}
