import 'package:ekomonitor/data/user_profile/enums/user_profile_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';



@JsonSerializable()
class UserProfileModel {
  final int answerId;
  final int userId;
  final List<String> answers;
  final UserProfileEnum userProfile;

  UserProfileModel({
    required this.answerId,
    required this.userId,
    required this.answers,
    required this.userProfile,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}
