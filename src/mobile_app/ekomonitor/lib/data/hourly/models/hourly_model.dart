import 'package:ekomonitor/data/measurement/models/measurement_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ekomonitor/data/location/location_model.dart';

part 'hourly_model.g.dart';

@JsonSerializable()
class HourlyModel {
  final int timestamp;
  final LocationModel location;
  Map<String, MeasurementModel> weatherConditions;

  HourlyModel({required this.timestamp, required this.location, required this.weatherConditions});

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  factory HourlyModel.fromJson(Map<String, dynamic> json) =>
      _$HourlyModelFromJson(json);
  Map<String, dynamic> toJson() => _$HourlyModelToJson(this);
}
