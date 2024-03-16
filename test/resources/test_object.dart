import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'dungeon_config.dart';

class TestObject {
  final config = DungeonConfig();
  late Partition partition;

  TestObject() {
    // 初期partitionの作成
    var initialRect = List.generate(config.dungeonHeight,
            (i) => List.generate(config.dungeonWidth, (j) => 8));
    // 初期のエリアを作成
    var initialArea = Area(
        from: Point(y: 0, x: 0),
        to: Point(y: config.dungeonHeight - 1, x: config.dungeonWidth - 1));

    // partitionを作成
    partition = Partition(depth: 0, isRoot: true,
        rect: initialRect, absArea: initialArea, name: "r");
  }

}