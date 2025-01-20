import 'package:ekomonitor/models/weather_condition_unit.dart';

abstract class WthrConUnitService {
  Future<WthrConUnit> getWthrConUnit(String unitName);
}