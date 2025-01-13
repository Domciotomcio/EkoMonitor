import 'package:ekomonitor/data/hourly/params/hourly_params.dart';
import 'package:ekomonitor/data/hourly/providers/hourly_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HourlyTestView extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourlyAsyncValue = ref.watch(hourlyProvider(HourlyParams(
      latitude: 0.0,
      longitude: 0.0,
    )));

    return Scaffold(
      appBar: AppBar(
        title: Text('Hourly Test View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hourly Test Data',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}