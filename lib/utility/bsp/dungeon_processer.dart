import 'package:push_puzzle/utility/bsp/consolidator.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/partition_visitor.dart';
import 'package:push_puzzle/utility/bsp/room_creator_visitor.dart';
import 'package:push_puzzle/utility/bsp/Tracer.dart';

class DungeonProcessor {
  DungeonConfig d = DungeonConfig();
  CacheTracer t = CacheTracer();
  RoomCreatorVisitor roomCreator = RoomCreatorVisitor();
  ConsolidatorVisitor consolider = ConsolidatorVisitor();
  late Partition root;
  late List<List<int>> initialRect;
  //CorridorCreator corridorCreator = CorridorCreator();

  void process() {

    root = Partition.construct(
        depth: d.initialDepth, isRoot: d.initialIsRoot, rect: initialRect, name: d.rootName);

    PartitionVisitor visitor = PartitionVisitor();
    visitor.visit(root);

    consolider.visit(root);
    //t.trace2d(root.cache.getConsolidRect);

    roomCreator.visit(root);

    //consolider.consolid(root);
    //t.trace2d(root.cache.getConsolidRect);



  }

  DungeonProcessor() {
    //roomCreator = RoomCreator(config: dungeonConfig);
    initialRect = List.generate(d.dungeonHeight,
            (i) => List.generate(d.dungeonWidth, (j) => 8));

;}

}