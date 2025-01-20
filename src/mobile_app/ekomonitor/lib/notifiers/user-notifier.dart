import 'dart:convert';
import 'dart:developer';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/user/services/user_service.dart';
import 'package:ekomonitor/data/user_profile/enums/user_profile_enum.dart';
import 'package:ekomonitor/data/user_profile/models/user_profile_model.dart';
import 'package:ekomonitor/data/user_profile/providers/user_profile_provider.dart';
import 'package:ekomonitor/notifiers/main_tile_notifier.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:ekomonitor/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserNotifier extends StateNotifier<UserModel?> {
  final UserService _userService;
  final Ref ref;

  UserNotifier(this._userService, this.ref) : super(null);

  Future<bool> login(String email, String password) async {
    // await Future.delayed(Duration(seconds: 2));

    const email = "Test.userX@example.com"; // TODO: change to user input
    const password = "password123"; // TODO: change to user input

    // login request to server with email and password, return for me id
    int? userId;
    const url = '${USER_MANAGEMENT_URL}users/authenticate';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      userId = int.tryParse(response.body);

      if (userId == null) {
        log('Failed to login: ${response.body}');
        return false;
      }

      try {
        state = await _userService.getUserData(userId);
        // Update UserProfileNotifier
         await ref.read(userProfileProvider.notifier).fetchUserProfile(userId);

        // set main tile for user profile
        UserProfileModel? userProfile = ref.read(userProfileProvider);

        if (userProfile!.userProfile == UserProfileEnum.outdoorEnthusiast) {
          ref.read(mainTileProvider.notifier).setMainTile('outdoorEnthusiast');
        } else if (userProfile.userProfile == UserProfileEnum.gardener) {
          ref.read(mainTileProvider.notifier).setMainTile('gardener');
        } else {
          ref.read(mainTileProvider.notifier).setMainTile('default');
        }

        ref.read(themeProvider.notifier).setTheme(ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ref.read(mainTileProvider).color,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ));

          
      } catch (e) {
        log('Failed to login: $e');
        return false;
      }
    } else {
      log('Failed to login: ${response.statusCode}');
      return false;
    }
    return true;
  }

  void logout() {
    state = null;

    // Clear UserProfileNotifier state
    ref.read(userProfileProvider.notifier).setUserProfile(null);
  
  }
}
