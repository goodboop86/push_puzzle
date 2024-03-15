import 'package:push_puzzle/utility/bsp/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition/partition.dart';
import 'package:push_puzzle/utility/bsp/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/utility/bsp/visitor/room_creator_visitor.dart';

class DungeonProcessor {
  DungeonConfig d = DungeonConfig();
  PartitionCreatorVisitor visitor = PartitionCreatorVisitor();
  PartitionArrangerVisitor arranger = PartitionArrangerVisitor();
  RoomCreatorVisitor roomCreator = RoomCreatorVisitor();
  late Partition root;
  late List<List<int>> initialRect;

  void process() {

    root = Partition(
        depth: d.initialDepth, isRoot: d.initialIsRoot, rect: initialRect, name: d.rootName);

    visitor.visit(root, isDebug: false);

    arranger.visit(root, isDebug: false);

    roomCreator.visit(root, isDebug: false);

    // arranger.visit(root);


  }

  DungeonProcessor() {
    initialRect = List.generate(d.dungeonHeight,
            (i) => List.generate(d.dungeonWidth, (j) => 8));

}

}