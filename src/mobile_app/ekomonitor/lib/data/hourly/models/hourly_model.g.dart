// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HourlyModel _$HourlyModelFromJson(Map<String, dynamic> json) => HourlyModel(
      timestamp: (json['timestamp'] as num).toInt(),
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      weatherConditions:
          (json['weatherConditions'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, MeasurementModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$HourlyModelToJson(HourlyModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'location': instance.location,
      'weatherConditions': instance.weatherConditions,
    };
