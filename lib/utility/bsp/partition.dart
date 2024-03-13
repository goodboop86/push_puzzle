import 'dart:math';

import 'package:push_puzzle/utility/bsp/consolidator.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition_visitor.dart';
import 'package:push_puzzle/utility/bsp/room_creator_visitor.dart';
import 'package:push_puzzle/utility/bsp/Tracer.dart';

import 'area.dart';
import 'partition_cache.dart';

class Partition {
  late List<Partition> children;
  late int depth;
  late PartitionCache cache = PartitionCache();
  late DungeonConfig config = DungeonConfig();
  // late RoomCreatorVisitor roomCreator = RoomCreatorVisitor(config: config);
  late int id;



  // List<List<int>> getMergedRect(){
  //   bool isEdge = children.isEmpty;
  //   CacheTracer u = CacheTracer();
  //   if(isEdge) {
  //     return cache.getRect;
  //   } else {
  //     //要素2
  //     List<List<List<int>>> pair =[];
  //     children.forEach((child) {pair.add(child.getMergedRect());});
  //
  //     if (cache.getSplitAxis == "horizontal") {
  //       return pair[0] + pair[1];
  //     } else if (cache.getSplitAxis == "vertical") {
  //       List<List<int>> merged = [];
  //       for (int i = 0; i < pair[0].length; i++) {
  //         merged.addAll([pair[0][i] + pair[1][i]]);
  //       }
  //       return merged;
  //     } else {
  //       // 無い想定
  //       Exception();
  //       return [];
  //     }
  //   }
  // }

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
    if (depth < 3){
      depth += 1;
      visitor.createChildren(this);
    }
  }

  void acceptRoomCreatorVisitor(RoomCreatorVisitor visitor){
    visitor.createRoomIfIsEdge(this);
  }

  void acceptConsolidatorVisitor(ConsolidatorVisitor visitor){
    // 各TreeのconsolidRectはそれぞれのcacheに格納されるので戻す必要はない。
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