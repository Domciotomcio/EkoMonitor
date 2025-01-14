// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historical_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoricalModel _$HistoricalModelFromJson(Map<String, dynamic> json) =>
    HistoricalModel(
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      weatherData: (json['weather_data'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                  k, MeasurementModel.fromJson(e as Map<String, dynamic>)),
            )),
      ),
    );

Map<String, dynamic> _$HistoricalModelToJson(HistoricalModel instance) =>
    <String, dynamic>{
      'location': instance.location,
      'weather_data': instance.weatherData,
    };
