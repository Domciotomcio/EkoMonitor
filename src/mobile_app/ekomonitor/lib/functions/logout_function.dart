import 'dart:developer';

import 'package:ekomonitor/data/user/models/user_model.dart';
import 'package:ekomonitor/notifiers/main_tile_notifier.dart';
import 'package:ekomonitor/notifiers/user-notifier.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:ekomonitor/routes/fade_route.dart';
import 'package:ekomonitor/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void logoutFunction(BuildContext context, WidgetRef ref) {
  log('Logout');
  ref.read(userProvider.notifier).logout();
  ref.read(mainTileProvider.notifier).setMainTile('default');
  ref.read(themeProvider.notifier).setTheme(ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
        ),
        brightness: Brightness.light,
      ));
  //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  Navigator.pushAndRemoveUntil(
      context, FadeRoute(page: HomePage()), (route) => false);
}
