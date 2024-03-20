import 'package:push_puzzle/bsp/area.dart';
import 'package:push_puzzle/bsp/processor/processor.dart';
import 'package:push_puzzle/bsp/strategy/strategy_material.dart';
import 'package:push_puzzle/bsp/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/bsp/visitor/partition_leaf_accessor_visitor.dart';
import 'package:push_puzzle/bsp/visitor/visitor_config.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';
import 'package:push_puzzle/bsp/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/bsp/visitor/room_creator_visitor.dart';

class TreeProcessor extends Processor{
  VisitorConfig config = VisitorConfig();
  late PartitionCreatorVisitor partitionCreator;
  late PartitionArrangerVisitor partitionArranger;
  late RoomCreatorVisitor roomCreator;
  late PartitionLeafAccessorVisitor leafAccessor;
  late Partition root;

  // Root Partitionの設定値
  final int initialDepth = 0; //don't change
  final bool initialIsRoot = true; //don't change
  final String initialRootName = "r"; //don't change
  late List<List<int>> initialRect;
  late Area initialArea;

  @override
  StrategyMaterial process() {
    root = Partition(
        depth: initialDepth,
        isRoot: initialIsRoot,
        rect: initialRect,
        absArea: initialArea,
        name: initialRootName,
        config: config);

    partitionCreator.visit(root, isDebug: false);
    roomCreator.visit(root, isDebug: false);

    List<Partition> leafs = leafAccessor.visit(root, isDebug: false);
    List<List<int>> field = partitionArranger.visit(root, isDebug: false);

    StrategyMaterial result = StrategyMaterial(leafs: leafs, field: field, edges: []);

    return StrategyMaterial(leafs: leafs, field: field, edges: []);
  }

  TreeProcessor() {
    initialRect = List.generate(config.dungeonHeight,
        (i) => List.generate(config.dungeonWidth, (j) => 0));
    initialArea = Area(
        from: Point(y: 0, x: 0),
        to: Point(y: config.dungeonHeight - 1, x: config.dungeonWidth - 1));

    partitionCreator = PartitionCreatorVisitor(
        config: config, adjustor: PartitionCreatorAdjustor());
    roomCreator =
        RoomCreatorVisitor(config: config, adjustor: RoomCreatorAdjustor());
    leafAccessor = PartitionLeafAccessorVisitor(config: config);
    partitionArranger = PartitionArrangerVisitor(config: config);
  }
}
