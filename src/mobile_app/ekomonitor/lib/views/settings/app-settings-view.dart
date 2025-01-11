import 'package:flutter/material.dart';

class AppSettingsView extends StatelessWidget {
  const AppSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ustawienia aplikacji'),
        ),
        body: Center(
          child: FilledButton.icon(
              onPressed: () {},
              label: Text("Zresetuj ustawienia aplikacji"),
              icon: Icon(Icons.restore)),
        ));
  }
}
