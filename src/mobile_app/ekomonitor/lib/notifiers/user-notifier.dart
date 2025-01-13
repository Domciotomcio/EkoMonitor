import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user/models/user_model.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  Future<void> login(String email, String password) async {
    // Mock server response
    await Future.delayed(Duration(seconds: 2));

    //if ok, return for me id

    // send request for user data to server with id

    // send request for user profile data to server with id


    state = UserModel(
      firstName: 'John',
      lastName: 'Doe',
      city: 'New York',
      email: email,
    );
  }

  void logout() {
    state = null;
  }
}