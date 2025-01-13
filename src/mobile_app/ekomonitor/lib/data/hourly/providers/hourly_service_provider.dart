import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/hourly/services/hourly_api_service.dart';
import 'package:ekomonitor/data/hourly/services/hourly_mock_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hourlyServiceProvider = Provider((ref) {
  const bool useMockService = USE_MOCK_SERVICE;

  if (useMockService) {
    return HourlyMockService();
  } else {
    return HourlyApiService();
  }
});
