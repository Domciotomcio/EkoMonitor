import 'package:ekomonitor/data/hourly/providers/hourly_service_provider.dart';
import 'package:ekomonitor/data/hourly/repositories/hourly_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final hourlyRepositoryProvider = Provider((ref) {
  final service = ref.watch(hourlyServiceProvider);
  return HourlyRepository(service);
});