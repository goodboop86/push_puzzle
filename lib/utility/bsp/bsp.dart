// https://varav.in/archive/dungeon/

import 'dart:math';
import 'dart:core';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/room_creator.dart';
import 'package:push_puzzle/utility/bsp/util.dart';


void main() {
  Util u = Util();
  DungeonConfig config = DungeonConfig();

  List<List<int>> rect = List.generate(config.dungeonHeight,
      (i) => List.generate(config.dungeonWidth, (j) => config.dungeonWidth * i + j));
  Partition root = Partition(rect: rect, depth: 0, isRoot: true, name: "r");

  //List<List<int>> merged = root.getMergedRect();
  //print("===merged===");
  //u.trace2d(merged);
  //root.echoMyName();
  
  // RoomCreator creator = RoomCreator(config: DungeonConfig());
  // var res = creator.create(rect);
  // u.trace2d(res);

  root.createRoom();
  var res = root.getMergedRect();
  u.trace2d(res);
}
