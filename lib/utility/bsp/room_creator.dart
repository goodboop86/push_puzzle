
import 'dart:math';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';

class RoomCreator {
  late DungeonConfig config;
  late int minRoomSize;
  late int margin;
  late double gridRatio;

  late int gridHeight;
  late int gridWidth;

  bool isCreatable(List<List<int>> leaf) {
    int leafHeight = leaf.length;
    int leafWidth = leaf.first.length;

    // グリッドサイズ: 部屋を作成できる空間
    gridHeight = leafHeight - margin * 2;
    gridWidth = leafWidth - margin * 2;

    // 作成する部屋のサイズが小さすぎないか
    bool isEnoughRoomSize =
    (gridWidth > minRoomSize) && (gridHeight > minRoomSize) ? true : false;

    return  isEnoughRoomSize;
  }


  List<List<int>> create(List<List<int>> leaf){

    if(isCreatable(leaf)) {
      // 最小部屋サイズが4、グリッドサイズ20なら 4~10になる
      int rh = Random().nextInt(gridHeight - minRoomSize) +
          minRoomSize; // roomHeight
      int rw = Random().nextInt(gridWidth - minRoomSize) +
          minRoomSize; // roomWidth

      // 部屋とグリッドとの距離をランダムに決める
      int hb = Random().nextInt(gridHeight - rh); // heightBias
      int wb = Random().nextInt(gridWidth - rw); // widthBias

      // 部屋を描画する範囲
      bool isInRoomRange(int y, int x) =>
          y >= margin + hb && y <= margin + hb + rh &&
              x >= margin + wb && x <= margin + wb + rw;


      //List<List<int>> room = [];
      for (int y = 0; y < leaf.length; y++) {
        for (int x = 0; x < leaf.first.length; x++) {
          if (isInRoomRange(y, x)) {
            leaf[y][x] = 0;
          }
        }
      }

      return leaf;
    } else {
      Exception();
      return leaf;
    }
  }

  RoomCreator({required this.config}) {
    minRoomSize =  config.minRoomSize;
    margin = config.minMarginBetweenLeaf;
    gridRatio = config.gridRatio;
}
}