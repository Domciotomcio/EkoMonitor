import 'package:flutter/material.dart';

class UserSettingsView extends StatelessWidget {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia użytkownika'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text("Opcja 1"),
            subtitle: Text("Opis opcji 1"),
            leading: Icon(Icons.person),
          ),
          const ListTile(
            title: Text("Opcja 2"),
            subtitle: Text("Opis opcji 2"),
            leading: Icon(Icons.person),
          ),
          const ListTile(
            title: Text("Opcja 3"),
            subtitle: Text("Opis opcji 3"),
            leading: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
