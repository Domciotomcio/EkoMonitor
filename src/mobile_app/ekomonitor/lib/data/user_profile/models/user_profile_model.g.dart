// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      answerId: (json['answerId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
      userProfile: $enumDecode(_$UserProfileEnumEnumMap, json['userProfile']),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'answerId': instance.answerId,
      'userId': instance.userId,
      'answers': instance.answers,
      'userProfile': _$UserProfileEnumEnumMap[instance.userProfile]!,
    };

const _$UserProfileEnumEnumMap = {
  UserProfileEnum.outdoorEnthusiast: 'Outdoor Enthusiast',
  UserProfileEnum.healthConsciousIndividual: 'Health-Conscious Individual',
  UserProfileEnum.commuter: 'Commuter',
  UserProfileEnum.gardener: 'Gardener',
  UserProfileEnum.generalUser: 'General User',
};
