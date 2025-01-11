import 'package:ekomonitor/models/user.dart';
import 'package:ekomonitor/notifiers/user-notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});