import '../../models/weather_condition_description.dart';

abstract class WthrConDescService {
  Future<List<WthrConDesc>> getWeatherConditions();
  Future<WthrConDesc> getWeatherCondition(String conditionName);
}