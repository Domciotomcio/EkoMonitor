import 'package:ekomonitor/data/hourly/models/hourly_model.dart';
import 'package:ekomonitor/data/hourly/params/hourly_params.dart';
import 'package:ekomonitor/data/hourly/providers/hourly_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hourlyProvider = FutureProvider.family<HourlyModel, HourlyParams>((ref, params) {
  final repository = ref.watch(hourlyRepositoryProvider);
  return repository.getHourly(params.latitude, params.longitude);
});
