
import 'dart:math';

import 'package:push_puzzle/utility/bsp/area.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/util.dart';

class RoomCreator {
  late DungeonConfig config;
  late int minRoomSize;
  late int margin;
  late double gridRatio;

  late int gridHeight;
  late int gridWidth;
  late Area roomArea;
  late Area gridArea;

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
      roomArea = Area(
          from: Coordinate(y: margin + hb, x: margin + wb),
          to: Coordinate(y: margin + hb + rh -1, x: margin + wb + rw -1));

      // グリッドを描画する範囲
      gridArea = Area(
          from: Coordinate(y: margin, x: margin),
          to: Coordinate(y: leaf.length - margin -1, x: leaf.first.length - margin -1));

      for (int y = 0; y < leaf.length; y++) {
        for (int x = 0; x < leaf.first.length; x++) {
          if (gridArea.isIn(y, x)){
            leaf[y][x] = 1;
            if (roomArea.isIn(y, x)) {
              leaf[y][x] = 4;
            }
          }
        }
      }


      print("roomHeight: $rh, roomWidth: $rw");
      Util u = Util();
      u.trace2d(leaf);

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