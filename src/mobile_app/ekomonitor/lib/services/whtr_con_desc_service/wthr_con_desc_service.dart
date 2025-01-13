import '../../models/weather-condition-description.dart';

abstract class WthrConDescService {
  Future<List<WthrConDesc>> getWeatherConditions();
  Future<WthrConDesc> getWeatherCondition(String conditionName);
}