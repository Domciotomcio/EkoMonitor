import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Future<void> login(String email, String password) async {
    // Mock server response
    await Future.delayed(Duration(seconds: 2));
    state = User(id: '1', name: 'John Doe', email: email);
  }

  void logout() {
    state = null;
  }
}