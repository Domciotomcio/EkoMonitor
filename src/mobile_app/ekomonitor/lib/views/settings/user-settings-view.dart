import 'dart:developer';

import 'package:ekomonitor/data/user_profile/enums/user_profile_enum.dart';
import 'package:ekomonitor/data/user_profile/providers/user_profile_provider.dart';
import 'package:ekomonitor/functions/logout_function.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingsView extends ConsumerWidget {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User settings'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: user != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 100),
                  Text(user.firstName + " " + user.lastName,
                      style: const TextStyle(fontSize: 20)),
                  Text(user.email, style: const TextStyle(fontSize: 16)),
                  Text(userProfile!.userProfile.value,
                      style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  ListTile(
                    title: const Text('Change email'),
                    leading: const Icon(Icons.email),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Email change');
                      _showSnackBar(context, "Implemented in future");
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('Change password'),
                    leading: const Icon(Icons.lock),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Change password');
                      _showSnackBar(context, "Implemented in future");
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('Reset user settings'),
                    leading: const Icon(Icons.restore),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Reset user settings');
                      _showSnackBar(context, "Implemented in future");
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('Questioner for user settings'),
                    leading: const Icon(Icons.restore),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Questioner for user settings');
                      Navigator.of(context).pushNamed('/form');
                    },
                  ),
                  SizedBox(height: 16),
                  FilledButton.icon(
                      onPressed: () => logoutFunction(context, ref),
                      label: Text("Logout"),
                      icon: Icon(Icons.logout)),
                ],
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Text('Log in'),
                ),
              ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informacja'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Zamknij'),
            ),
          ],
        );
      },
    );
  }
}
