import 'package:ekomonitor/data/hourly/models/hourly_model.dart';
import 'package:ekomonitor/data/hourly/services/hourly_service.dart';

class HourlyMockService implements HourlyService {
  @override
  Future<HourlyModel> getHourlyData(double latitude, double longitude) {
    // TODO: implement getHourlyData
    throw UnimplementedError();
  }
  
}