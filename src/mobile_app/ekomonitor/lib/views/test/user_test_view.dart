import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTestView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Test View'),
      ),
      body: Column(
        children: [
          Text('This is the User Test View'),
          ElevatedButton(onPressed: () {
            // use the userProvider to fetch user data
            

          }, child: Text("Fetch user data")),
        ],
      ),
    );
  }
}
