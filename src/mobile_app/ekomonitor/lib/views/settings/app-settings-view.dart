import 'package:flutter/material.dart';

class AppSettingsView extends StatelessWidget {
  const AppSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('App settings'),
        ),
        body: Center(
          child: FilledButton.icon(
              onPressed: () {},
              label: Text("Restore default settings"),
              icon: Icon(Icons.restore)),
        ));
  }
}
