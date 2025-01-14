
import 'package:ekomonitor/data/location/location_model.dart';
import 'package:ekomonitor/data/measurement/models/measurement_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'historical_model.g.dart';

@JsonSerializable()
class HistoricalModel {
  final LocationModel location;
  @JsonKey(name: 'weather_data')
  final Map<String, Map<String, MeasurementModel>> weatherData;

  HistoricalModel({required this.location, required this.weatherData});

  factory HistoricalModel.fromJson(Map<String, dynamic> json) =>
      _$HistoricalModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoricalModelToJson(this);
}