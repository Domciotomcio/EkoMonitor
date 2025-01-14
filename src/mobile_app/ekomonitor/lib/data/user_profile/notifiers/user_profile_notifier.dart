import 'dart:developer';

import 'package:ekomonitor/data/user_profile/enums/user_profile_enum.dart';
import 'package:ekomonitor/data/user_profile/models/user_profile_model.dart';
import 'package:ekomonitor/data/user_profile/services/user_profile_service.dart';
import 'package:ekomonitor/views/form/form_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileNotifier extends StateNotifier<UserProfileModel?> {
  UserProfileNotifier(this._userProfileService) : super(null);
  final UserProfileService _userProfileService;

  void setUserProfile(UserProfileModel? userProfile) {
    state = userProfile;
  }

  Future<void> fetchUserProfile(int userId) async {
    // fetch user profile from server
    state = await _userProfileService.getUserProfileData(userId);
    log("User profile fetched, state: ${state!.userProfile.value}");
  }

  Future<void> updateUserProfileWithForm(int userId, List<Question> questions) async {
    await _userProfileService.updateUserProfileWithForm(userId.toString(), questions);
    log("User profile updated");
    }
}
