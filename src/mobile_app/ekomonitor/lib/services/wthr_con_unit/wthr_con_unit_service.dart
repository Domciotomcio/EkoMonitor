import 'package:ekomonitor/models/weather-condition-unit.dart';

abstract class WthrConUnitService {
  Future<WthrConUnit> getWthrConUnit(String unitName);
}