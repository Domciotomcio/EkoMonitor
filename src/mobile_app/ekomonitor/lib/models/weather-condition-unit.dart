import 'package:ekomonitor/models/weather-condition-description.dart';

class WthrConUnit {
  final WthrConDesc wthrConDesc;
  final String value;

  const WthrConUnit({
    required this.wthrConDesc,
    required this.value,
  });

  factory WthrConUnit.fromJson(Map<String, dynamic> json) {
    return WthrConUnit(
      wthrConDesc: WthrConDesc.fromJson(json['wthrConDesc']),
      value: json['value'],
    );
  }
}
