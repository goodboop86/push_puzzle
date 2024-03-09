// https://varav.in/archive/dungeon/

import 'dart:math';
import 'dart:core';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/util.dart';


// 2重リストが2個
List<List<List<int>>> split(List<List<int>> arr, DungeonConfig config) {
  int height = arr.length;
  int width = arr.first.length;
  double ratio = config.splitRatio;
  String axis = config.splitAxis;

  if (axis == "horizontal") {
    int idx = (height * ratio).toInt();
    // 第２引数の配列番号は含まれない
    return [arr.sublist(0, idx), arr.sublist(idx, height)];
  } else if (axis == "vertical") {
    int idx = (width * ratio).toInt();
    return [
      arr.map((row) => row.sublist(0, idx)).toList(),
      arr.map((row) => row.sublist(idx, width)).toList()
    ];
  }
  throw Exception();
}

void main() {
  Util u = Util();
  int height = 5;
  int width = 10;

  DungeonConfig config =
      DungeonConfig(dungeonHeight: 5, dungeonWidth: 10, minMapSize: 3);

  List<List<int>> root = List.generate(config.dungeonHeight,
      (i) => List.generate(config.dungeonWidth, (j) => 10 * i + j));
  List<List<List<int>>> res = split(root, config);
  u.trace3d(res);

  /*
  DungeonCreator dungeonCreator =
      DungeonCreator(dungeonSize: 20, minMapSize: 5);
  Util u = Util();
  u.trace2d(dungeonCreator.dungeon);
  */
}
