// https://varav.in/archive/dungeon/

import 'dart:math';
import 'dart:core';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/dungeon_processer.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/room_creator_visitor.dart';
import 'package:push_puzzle/utility/bsp/util.dart';


Future<void> main() async {
  DungeonProcessor().process();
}
