import 'package:ekomonitor/data/main-tile-dic.dart';
import 'package:ekomonitor/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekomonitor/widgets/main-tile.dart';

class MainTileNotifier extends StateNotifier<MainTileConfig> {
  MainTileNotifier() : super(mainTileDict[MAIN_TILE_CODE]!);

  void setMainTile(String code) {
    state = mainTileDict[code] ?? mainTileDict[MAIN_TILE_CODE]!;
  }
}

final mainTileProvider = StateNotifierProvider<MainTileNotifier, MainTileConfig>((ref) {
  return MainTileNotifier();
});