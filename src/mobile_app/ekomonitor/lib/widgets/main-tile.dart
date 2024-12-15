import 'package:ekomonitor/data/main-tile-dic.dart';
import 'package:ekomonitor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainTileConfig {
  final String code;
  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;

  const MainTileConfig({
    required this.code,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class MainTile extends ConsumerWidget {
  MainTileConfig config = mainTileDict[MAIN_TILE_CODE]!;

  MainTile({
    super.key,
  });

  get title => config.title;
  get subtitle => config.subtitle;
  get icon => config.icon;
  get color => config.color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProvider = ref.watch(weatherStatusNotifierProvider);
    config = myProvider.mainTileConfig;

    return Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
            color: config.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitle, style: const TextStyle(color: Colors.white)),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                left: 8,
                bottom: 8),
            Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  icon,
                  size: 64,
                  color: Colors.white,
                )),
          ],
        ));
  }
}
