import 'package:push_puzzle/utility/bsp/consolidator.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition_visitor.dart';
import 'package:push_puzzle/utility/bsp/room_creator_visitor.dart';
import 'package:logging/logging.dart';
import 'area.dart';
import 'partition_cache.dart';
import 'package:push_puzzle/utility/bsp/extention/list2d_extention.dart';


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
      children.forEach((child) {
        roomAreas = child.getRoomAreas(roomAreas);});
    }
    return roomAreas;
  }


  void acceptPartitionVisitor(PartitionVisitor visitor){
      log.info("##### Create a partition with depth: ${cache.getSplitDepth} #####");
      visitor.createChildren(this);
  }

  void acceptRoomCreatorVisitor(RoomCreatorVisitor visitor){
    visitor.createRoomIfIsEdge(this);
  }

  void acceptConsolidatorVisitor(ConsolidatorVisitor visitor){
    log.info("##### consolid a rect. depth: ${cache.getSplitDepth} #####");
    // 各Treeの結合配列はそれぞれのcacheに格納されるので戻す必要はない。
    var _ = visitor.consolid(this);
  }

  Partition.construct({required this.depth, required isRoot, required List<List<int>> rect, required String name}) {
    cache.rect = rect;
    cache.isRoot = isRoot;
    cache.name = name;
  }

  Partition({required this.depth, required isRoot, required List<List<int>> rect, required String name}) {

    cache.rect = rect;
    cache.isRoot = isRoot;
    cache.name = name;
    depth += 1;
    // 元のコードを動かしたい場合は外す。
    //createChildren();
  }
}