import 'package:json_annotation/json_annotation.dart';

part 'forecast_model.g.dart';

@JsonSerializable()
class ForecastModel {
  @JsonKey(name: 'Precipitation')
  final double precipitation;
  @JsonKey(name: 'Precipitation Probability')
  final double precipitationProbability;
  @JsonKey(name: 'Cloudiness')
  final double cloudiness;
  @JsonKey(name: 'Temperature')
  final double temperature;
  @JsonKey(name: 'Pressure')
  final double pressure;
  @JsonKey(name: 'Humidity')
  final double humidity;
  @JsonKey(name: 'Visibility')
  final double visibility;
  @JsonKey(name: 'Wind Speed')
  final double windSpeed;
  @JsonKey(name: 'Wind Degrees')
  final double windDegrees;
  @JsonKey(name: 'pm10')
  final double pm10;
  @JsonKey(name: 'pm2_5')
  final double pm25;
  @JsonKey(name: 'aqi')
  final double aqi;

  ForecastModel({
    required this.precipitation,
    required this.precipitationProbability,
    required this.cloudiness,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.windDegrees,
    required this.pm10,
    required this.pm25,
    required this.aqi,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastModelFromJson(json);

  @override
  String toString() {
    return 'ForecastModel(precipitation: $precipitation, precipitationProbability: $precipitationProbability, cloudiness: $cloudiness, temperature: $temperature, pressure: $pressure, humidity: $humidity, visibility: $visibility, windSpeed: $windSpeed, windDegrees: $windDegrees, pm10: $pm10, pm25: $pm25, aqi: $aqi)';
  }
}
