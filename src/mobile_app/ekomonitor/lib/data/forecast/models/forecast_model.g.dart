// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) =>
    ForecastModel(
      precipitation: (json['Precipitation'] as num).toDouble(),
      precipitationProbability:
          (json['Precipitation Probability'] as num).toDouble(),
      cloudiness: (json['Cloudiness'] as num).toDouble(),
      temperature: (json['Temperature'] as num).toDouble(),
      pressure: (json['Pressure'] as num).toDouble(),
      humidity: (json['Humidity'] as num).toDouble(),
      visibility: (json['Visibility'] as num).toDouble(),
      windSpeed: (json['Wind Speed'] as num).toDouble(),
      windDegrees: (json['Wind Degrees'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      pm25: (json['pm2_5'] as num).toDouble(),
      aqi: (json['aqi'] as num).toDouble(),
    );

Map<String, dynamic> _$ForecastModelToJson(ForecastModel instance) =>
    <String, dynamic>{
      'Precipitation': instance.precipitation,
      'Precipitation Probability': instance.precipitationProbability,
      'Cloudiness': instance.cloudiness,
      'Temperature': instance.temperature,
      'Pressure': instance.pressure,
      'Humidity': instance.humidity,
      'Visibility': instance.visibility,
      'Wind Speed': instance.windSpeed,
      'Wind Degrees': instance.windDegrees,
      'pm10': instance.pm10,
      'pm2_5': instance.pm25,
      'aqi': instance.aqi,
    };
