// https://varav.in/archive/dungeon/

import 'dart:core';

import 'package:logging/logging.dart';
import 'package:push_puzzle/utility/bsp/dungeon_processer.dart';


void main() {
  Logger.root.level = Level.ALL; // すべてのログを取得します。
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  DungeonProcessor().process();
}
