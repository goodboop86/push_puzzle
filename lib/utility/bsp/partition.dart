
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition_visitor.dart';
import 'package:push_puzzle/utility/bsp/room_creator.dart';
import 'package:push_puzzle/utility/bsp/util.dart';

import 'area.dart';
import 'partition_repository.dart';

class Partition {
  late List<Partition> children;
  late int depth;
  late PartitionRepository repo = PartitionRepository();
  late DungeonConfig config = DungeonConfig();
  late RoomCreator roomCreator = RoomCreator(config: config);

  void accept(PartitionVisitor visitor){
    //visitor.storeData(this);
    if (depth < 3){
      visitor.createChildren(this);
      //children.map((child) => visitor.visit(child));
    }
  }


  List<List<int>> getMergedRect(){
    bool isEdge = children.isEmpty;
    if(isEdge) {
      return repo.getRect;
    } else {
      //要素2
      List<List<List<int>>> pair =[];

      for (var child in children) {pair.add(child.getMergedRect());}
      //children.forEach((child) {pair.add(child.getMergedRect());});

      if (repo.getSplitAxis == "horizontal") {
        return pair[0] + pair[1];
      } else if (repo.getSplitAxis == "vertical") {
        List<List<int>> merged = [];
        for (int i = 0; i < pair[0].length; i++) {
          merged.addAll([pair[0][i] + pair[1][i]]);
        }
        return merged;
      } else {
        // 無い想定
        Exception();
        return [];
      }
    }
  }

  List<Area> getRoomAreas(List<Area> roomAreas) {
    // 末端のnodeを指定して生成する必要がある。
    if(children.isEmpty) {
      roomAreas.add(repo.getRoomArea);
      return roomAreas;
    } else {
      // 末端でなければ子階層を呼び出す。
      for (var child in children) {child.getRoomAreas(roomAreas);}
      //children.forEach((child) { roomAreas = child.getRoomAreas(roomAreas);});
    }
    return roomAreas;
  }

  void createRoomIfIsEdge() {
    // 末端のnodeを指定して生成する必要がある。
    if(children.isEmpty) {
      var rect = repo.getRect;
      repo.rect = roomCreator.createAndUpdateAreas(rect);
      // 後のMSTで通路を決める際に利用
      // repo.roomArea = roomCreator.getRoomArea;
    } else {
      // 末端でなければ子階層を呼び出す。
      for (var child in children) {child.createRoomIfIsEdge();}
      //children.forEach((child) {child.createRoomIfIsEdge();});
    }
  }


  // FIXME: tracerはvisitorの方がよさそう.
  // FIXME: あとroomCreateするときに葉のNodeのrectが必要になるから、それもvisitorの方が良いと思われる。
  // 再帰処理はparitionに任せたほうが良さそう。
  void traceInfo(){
    print("#########################\n"
        "PARTITION INFO\n"
        "Root: ${repo.getIsRoot}, depth: ${repo.getDepth}/${repo.getSplitDepth}, Debug: ${repo.getIsDebug}\n"
        "name: ${repo.getName}, Split axis: ${repo.getSplitAxis} (bias: ±${repo.getSplitAxisBias}), Split ratio: ${repo.getSplitRatio} (bias: ±${repo.getSplitRatioBias})\n"
    );
    Util().trace2d(repo.getRect);
    if(children.isNotEmpty) {
      for (var child in children) {child.traceInfo();}
      //children.forEach((child) {child.traceInfo();});
    }
  }

  // visitor用
  Partition.initialize(PartitionVisitor v,{required this.depth, required isRoot, required rect, required String name}){

    children =[]; //FIXME: 暫定処理

    repo.rect = rect;
    repo.isRoot = isRoot;
    repo.name = name;
    depth += 1;
  }

  // visitor用
  Partition.initialize_(int i);

  Partition({required this.depth, required isRoot, required List<List<int>> rect, required String name}) {
    repo.rect = rect;
    repo.isRoot = isRoot;
    repo.name = name;
    depth += 1;
    // createChildren();
  }
}