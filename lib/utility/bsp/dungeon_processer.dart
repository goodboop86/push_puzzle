import 'package:push_puzzle/utility/bsp/corridor_crator.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/room_creator.dart';
import 'package:push_puzzle/utility/bsp/util.dart';

class DungeonProcessor {
  DungeonConfig dungeonConfig = DungeonConfig();
  Util u = Util();
  late RoomCreator roomCreator;
  late Partition root;
  late List<List<int>> initialRect;
  //CorridorCreator corridorCreator = CorridorCreator();

  void process() {
    root = Partition(
        depth: dungeonConfig.initialDepth,
        isRoot: dungeonConfig.initialIsRoot,
        rect: initialRect,
        name: dungeonConfig.rootName);

    root.traceInfo();

    u.trace2d(root.getMergedRect());

    root.createRoomIfIsEdge();

    u.trace2d(root.getMergedRect());

  }

  DungeonProcessor() {
    roomCreator = RoomCreator(config: dungeonConfig);
    initialRect = List.generate(dungeonConfig.dungeonHeight,
            (i) => List.generate(dungeonConfig.dungeonWidth, (j) => 8));

;}

}