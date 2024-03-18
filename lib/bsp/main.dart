// https://varav.in/archive/dungeon/

import 'dart:core';

import 'package:logging/logging.dart';
import 'package:push_puzzle/bsp/processor/tree_processor.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';

void main() {
  Logger.root.level = Level.ALL; // すべてのログを取得します。
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  ({List<Partition> leafs, List<List<int>> field}) context = TreeProcessor().process();

}
