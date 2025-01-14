import 'package:ekomonitor/data/user_profile/models/user_profile_model.dart';
import 'package:ekomonitor/data/user_profile/notifiers/user_profile_notifier.dart';
import 'package:ekomonitor/data/user_profile/services/user_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileModel?>((ref) {
  return UserProfileNotifier(UserProfileService());
});