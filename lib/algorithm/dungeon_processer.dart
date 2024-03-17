import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/partition_leaf_accesor_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/visitor_config.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/room_creator_visitor.dart';

class DungeonProcessor {
  VisitorConfig config = VisitorConfig();
  late PartitionCreatorVisitor visitor;
  late PartitionArrangerVisitor arranger;
  late RoomCreatorVisitor roomCreator;
  late PartitionLeafAccessorVisitor accessor;
  late Partition root;

  // Root Partitionの設定値
  final int initialDepth = 0; //don't change
  final bool initialIsRoot = true; //don't change
  final String initialRootName = "r"; //don't change
  late List<List<int>> initialRect;
  late Area initialArea;

  void process() {
    root = Partition(
        depth: initialDepth,
        isRoot: initialIsRoot,
        rect: initialRect,
        absArea: initialArea,
        name: initialRootName,
        config: config);

    visitor = PartitionCreatorVisitor(config: config, adjustor: PartitionCreatorAdjustor());
    visitor.visit(root, isDebug: false);

    //arranger.visit(root, isDebug: false);

    roomCreator = RoomCreatorVisitor(config: config, adjustor: RoomCreatorAdjustor());
    roomCreator.visit(root, isDebug: false);

    arranger = PartitionArrangerVisitor(config: config);
    arranger.visit(root, isDebug: true);

    accessor = PartitionLeafAccessorVisitor(config: config);
    List<Partition> leafs = accessor.visit(root, isDebug: false);

    // arranger.visit(root);
  }

  DungeonProcessor() {
    initialRect = List.generate(config.dungeonHeight,
        (i) => List.generate(config.dungeonWidth, (j) => 8));
    initialArea = Area(
        from: Point(y: 0, x: 0),
        to: Point(y: config.dungeonHeight - 1, x: config.dungeonWidth - 1));
  }
}
