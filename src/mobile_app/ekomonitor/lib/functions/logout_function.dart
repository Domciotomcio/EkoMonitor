import 'dart:developer';

import 'package:ekomonitor/models/user.dart';
import 'package:ekomonitor/notifiers/user-notifier.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void logoutFunction(BuildContext context, WidgetRef ref) {
  log('Logout');
  ref.read(userProvider.notifier).logout();
  Navigator.pushNamedAndRemoveUntil(
      context, '/home', (route) => false);
}
