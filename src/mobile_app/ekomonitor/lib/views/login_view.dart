import 'dart:developer';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/hourly/providers/hourly_provider.dart';
import 'package:ekomonitor/data/user_profile/providers/user_profile_provider.dart';
import 'package:ekomonitor/notifiers/main_tile_notifier.dart';
import 'package:ekomonitor/providers/theme_provider.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:ekomonitor/themes/theme1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Ekomonitor App",
                style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await ref.read(userProvider.notifier).login(
                          _emailController.text, _passwordController.text);
                      await ref
                          .read(hourlyProvider.notifier)
                          .fetchHourly(LATITUDE, LONGITUDE);
                      setState(() {
                        _isLoading = false;
                      });
                      if (ref.read(userProvider) != null) {
                        log('Login success');
                        log('User: ${ref.read(userProvider)!.email}');

                        ref.read(mainTileProvider.notifier).setMainTile(
                            ref.read(userProfileProvider)!.userProfile.name);

                        // set theme provider
                        ref.read(themeProvider.notifier).setTheme(ThemeData(
                              colorScheme: ColorScheme.fromSeed(
                                seedColor: ref.read(mainTileProvider).color,
                                brightness: Brightness.light,
                              ),
                              useMaterial3: true,
                            ));

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login failed'),
                          ),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
