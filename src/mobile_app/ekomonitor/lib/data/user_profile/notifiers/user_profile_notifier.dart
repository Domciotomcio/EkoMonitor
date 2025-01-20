import 'dart:developer';

import 'package:ekomonitor/data/user_profile/enums/user_profile_enum.dart';
import 'package:ekomonitor/data/user_profile/models/user_profile_model.dart';
import 'package:ekomonitor/data/user_profile/services/user_profile_service.dart';
import 'package:ekomonitor/notifiers/main_tile_notifier.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:ekomonitor/views/form/form_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileNotifier extends StateNotifier<UserProfileModel?> {
  UserProfileNotifier(this._userProfileService, this.ref) : super(null);
  final UserProfileService _userProfileService;
  final Ref ref;

  void setUserProfile(UserProfileModel? userProfile) {
    state = userProfile;
  }

  Future<void> fetchUserProfile(int userId) async {
    // fetch user profile from server
    state = await _userProfileService.getUserProfileData(userId);
    log("User profile fetched, state: ${state!.userProfile.value}");

    // user profile fetched, update main tile and theme
    ref.read(mainTileProvider.notifier).setMainTile(state!.userProfile.name);
    ref
        .read(themeProvider.notifier)
        .setThemeByColor(ref.read(mainTileProvider).color);
  }

  Future<void> updateUserProfileWithForm(
      int userId, List<Question> questions) async {
    await _userProfileService.updateUserProfileWithForm(
        userId.toString(), questions);

    // user profile might have changed, fetch it again
    await fetchUserProfile(userId);
    log("User profile updated");
  }
}
