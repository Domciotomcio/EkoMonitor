import 'dart:developer';

import 'package:ekomonitor/functions/logout_function.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingsView extends ConsumerWidget {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia użytkownika'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: user != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 100),
                  Text('Tomasz123', style: const TextStyle(fontSize: 20)),
                  Text('Tomasz123@gmail.com'),
                  SizedBox(height: 16),
                  ListTile(
                    title: const Text('Zmień email'),
                    leading: const Icon(Icons.email),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Email change');
                      // Navigator.of(context).pushNamed('/change-email');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('Zmień hasło'),
                    leading: const Icon(Icons.lock),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Change password');
                      //Navigator.of(context).pushNamed('/change-password');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('Zresetuj ustawienia użytkownika'),
                    leading: const Icon(Icons.restore),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Reset user settings');
                      // Navigator.of(context).pushNamed('/change-password');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('Wykonaj ponownie ankietę'),
                    leading: const Icon(Icons.restore),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      log('Questioner for user settings');
                      // Navigator.of(context).pushNamed('/change-password');
                    },
                  ),
                  SizedBox(height: 16),
                  FilledButton.icon(
                      onPressed: () => logoutFunction(context, ref),
                      label: Text("Wyloguj"),
                      icon: Icon(Icons.logout)),
                ],
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Text('Zaloguj'),
                ),
              ),
      ),
    );
  }
}
