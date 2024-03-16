import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/algorithm/dungeon_config.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/room_creator_visitor.dart';

class DungeonProcessor {
  DungeonConfig config = DungeonConfig();
  late PartitionCreatorVisitor visitor;
  late PartitionArrangerVisitor arranger;
  late RoomCreatorVisitor roomCreator;
  late Partition root;
  late List<List<int>> initialRect;
  late Area initialArea;

  void process() {
    root = Partition(
        depth: config.initialDepth,
        isRoot: config.initialIsRoot,
        rect: initialRect,
        absArea: initialArea,
        name: config.rootName,
        config: config);

    visitor = PartitionCreatorVisitor(config: config);
    visitor.visit(root, isDebug: true);

    //arranger.visit(root, isDebug: false);

    roomCreator = RoomCreatorVisitor(config: config);
    roomCreator.visit(root, isDebug: true);

    arranger = PartitionArrangerVisitor(config: config);
    arranger.visit(root, isDebug: true);

    // arranger.visit(root);
  }

  DungeonProcessor() {
    initialRect = List.generate(
        config.dungeonHeight, (i) => List.generate(config.dungeonWidth, (j) => 8));
    initialArea = Area(
        from: Point(y: 0, x: 0),
        to: Point(y: config.dungeonHeight - 1, x: config.dungeonWidth - 1));
  }
}
