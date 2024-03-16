import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/algorithm/dungeon_config.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/room_creator_visitor.dart';

class DungeonProcessor {
  DungeonConfig d = DungeonConfig();
  PartitionCreatorVisitor visitor = PartitionCreatorVisitor();
  PartitionArrangerVisitor arranger = PartitionArrangerVisitor();
  RoomCreatorVisitor roomCreator = RoomCreatorVisitor();
  late Partition root;
  late List<List<int>> initialRect;
  late Area initialArea;

  void process() {

    root = Partition(
        depth: d.initialDepth, isRoot: d.initialIsRoot, rect: initialRect, absArea: initialArea, name: d.rootName);

    visitor.visit(root, isDebug: true);

    //arranger.visit(root, isDebug: false);

    roomCreator.visit(root, isDebug: true);

    arranger.visit(root, isDebug: true);


    // arranger.visit(root);


  }

  DungeonProcessor() {
    initialRect = List.generate(d.dungeonHeight,
            (i) => List.generate(d.dungeonWidth, (j) => 8));
    initialArea = Area(from: Point(y: 0, x: 0), to: Point(y: d.dungeonHeight - 1, x: d.dungeonWidth - 1));

}

}