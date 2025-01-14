import 'dart:convert';
import 'dart:developer';

import 'package:ekomonitor/data/user/services/user_service.dart';
import 'package:ekomonitor/data/user_profile/providers/user_profile_provider.dart';
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
    const url = 'http://127.0.0.1:8004/users/authenticate';
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
          ref.read(userProfileProvider.notifier).fetchUserProfile(userId);
          
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
