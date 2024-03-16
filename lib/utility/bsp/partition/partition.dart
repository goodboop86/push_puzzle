import 'package:push_puzzle/utility/bsp/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/utility/bsp/visitor/room_creator_visitor.dart';
import 'package:logging/logging.dart';
import '../area.dart';
import 'partition_cache.dart';


class Partition {
  final log = Logger('Partition');
  List<Partition> children = [];
  late int depth;
  late PartitionCache cache = PartitionCache();
  late DungeonConfig config = DungeonConfig();
  late int id;


  List<Area> getRoomAreas(List<Area> roomAreas) {
    // 末端のnodeを指定して生成する必要がある。
    if(children.isEmpty) {
      roomAreas.add(cache.getRoomArea);
      return roomAreas;
    } else {
      // 末端でなければ子階層を呼び出す。
      for (var child in children) {
        roomAreas = child.getRoomAreas(roomAreas);}
    }
    return roomAreas;
  }


  void acceptPartitionVisitor(PartitionCreatorVisitor visitor){
      log.info("##### Create a partition with depth: ${cache.getSplitDepth} #####");
      visitor.execute(this);
  }

  void acceptRoomCreatorVisitor(RoomCreatorVisitor visitor){
    log.info("##### create room in rect. depth: ${cache.getSplitDepth} #####");
    visitor.execute(this);
  }

  void acceptConsolidatorVisitor(PartitionArrangerVisitor visitor){
    log.info("##### consolid a rect. depth: ${cache.getSplitDepth} #####");
    // 各Treeの結合配列はそれぞれのcacheに格納されるので戻す必要はない。
    var _ = visitor.execute(this);
  }

  Partition({required this.depth, required isRoot, required List<List<int>> rect, required Area absArea, required String name}) {
    cache.isRoot = isRoot;
    cache.rect = rect;
    cache.absArea = absArea;
    cache.name = name;
  }

}