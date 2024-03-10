// https://varav.in/archive/dungeon/

import 'dart:math';
import 'dart:core';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/util.dart';


void main() {
  Util u = Util();
  DungeonConfig config =
      DungeonConfig(dungeonHeight: 20, dungeonWidth: 10, minMapSize: 3);

  List<List<int>> rect = List.generate(config.dungeonHeight,
      (i) => List.generate(config.dungeonWidth, (j) => config.dungeonWidth * i + j));
  Partition root = Partition(config: config, rect: rect, depth: 0);

  List<List<int>> merged = root.mergedRect();

  print("===merged===");
  u.trace2d(merged);
}
