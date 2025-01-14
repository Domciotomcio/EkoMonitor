import 'package:ekomonitor/data/hourly/models/hourly_model.dart';
import 'package:ekomonitor/data/hourly/notifiers/hourly_notifier.dart';
import 'package:ekomonitor/data/hourly/services/hourly_api_service.dart';
import 'package:ekomonitor/data/hourly/services/hourly_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hourlyProvider = StateNotifierProvider<HourlyNotifier, HourlyModel?>((ref) {
  return HourlyNotifier(HourlyApiService(), ref);
});