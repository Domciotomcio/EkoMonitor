import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum UserProfileEnum {
  @JsonValue('Outdoor Enthusiast')
  outdoorEnthusiast,
  @JsonValue('Health-Conscious Individual')
  healthConsciousIndividual,
  @JsonValue('Commuter')
  commuter,
  @JsonValue('Gardener')
  gardener,
  @JsonValue('General User')
  generalUser
}

extension UserProfileEnumExtension on UserProfileEnum {
  String get value {
    switch (this) {
      case UserProfileEnum.outdoorEnthusiast:
        return 'Outdoor Enthusiast';
      case UserProfileEnum.healthConsciousIndividual:
        return 'Health-Conscious Individual';
      case UserProfileEnum.commuter:
        return 'Commuter';
      case UserProfileEnum.gardener:
        return 'Gardener';
      case UserProfileEnum.generalUser:
        return 'General User';
      default:
        return '';
    }
  }
}
