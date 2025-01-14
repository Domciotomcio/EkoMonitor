import 'package:ekomonitor/data/user/models/user_model.dart';
import 'package:ekomonitor/data/user/services/user_service.dart';
import 'package:ekomonitor/notifiers/user-notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier(UserService(), ref);
});