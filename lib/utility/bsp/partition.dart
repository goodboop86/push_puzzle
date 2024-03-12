import 'dart:math';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition_visitor.dart';
import 'package:push_puzzle/utility/bsp/room_creator_visitor.dart';
import 'package:push_puzzle/utility/bsp/util.dart';

import 'area.dart';
import 'partition_cache.dart';

class Partition {
  late List<Partition> children;
  late int depth;
  late PartitionCache cache = PartitionCache();
  late DungeonConfig config = DungeonConfig();
  // late RoomCreatorVisitor roomCreator = RoomCreatorVisitor(config: config);
  late int id;


  // 2次元配列をパラメータに従って分割する。
  List<List<List<int>>> split() {

    List<List<int>> rect = cache.getRect;
    int height = rect.length;
    int width = rect.first.length;
    cache.adjustSplitAxis();
    String axis = cache.getSplitAxis;
    cache.adjustSplitRatio();
    double ratio = cache.getSplitRatio;

    List<List<List<int>>>? pair = [];
    if (axis == "horizontal") {
      int idx = (height * ratio).toInt();
      // memo: sublistの第２引数の配列番号は含まれない
      pair = [
        rect.sublist(0, idx),
        rect.sublist(idx, height)
      ];
    } else if (axis == "vertical") {
      int idx = (width * ratio).toInt();
      pair = [
        rect.map((row) => row.sublist(0, idx)).toList(),
        rect.map((row) => row.sublist(idx, width)).toList()
      ];
    }

    // splitが作成されていなければexception(無い想定)
    if (pair.isEmpty) {
      throw Exception();
    } else {
      return pair;
    }
  }

  bool isCreateChildren() {
    bool isShouldCreate = depth < cache.getSplitDepth ? true : false;

    // - 分割可能かはsplit()で利用するsublistへ渡すindexによって代わる
    // - sublistはsublist(0,0)などでも空配列を返せるのでexceptionはしない
    // - なので判定はisEmptyで良いが要素数1の場合にloopが続くので1以上が良さそう
    // memo: min(splitRatio)=biasなので、index境界は bias * 縦or横幅の四捨五入
    // biasが0.3、幅3ならindex境界は0.9->1となりsublist(0,1), sublist(1,3)が成立する
    bool isCreatable = cache.getRect.length > 1;

    return isShouldCreate && isCreatable;
  }

  void createChildren() {
    children = [];
    // 分割回数が十分でないならchildrenの作成を繰り返す
    if (isCreateChildren()) {
      List<List<List<int>>> pair = split();
      cache.depth = depth;

      pair.asMap().forEach((int i, var leaf) {
        cache.leafNumber = i;
        cache.traceLeafWithInfo(leaf);
        children.add(Partition(rect: leaf, depth: depth, isRoot: false, name: cache.getName + cache.getLeafPosition()));
      });
    } else {
      cache.depth = depth;
    }
  }

  List<List<int>> getMergedRect(){
    bool isEdge = children.isEmpty;
    Util u = Util();
    if(isEdge) {
      return cache.getRect;
    } else {
      //要素2
      List<List<List<int>>> pair =[];
      children.forEach((child) {pair.add(child.getMergedRect());});

      if (cache.getSplitAxis == "horizontal") {
        return pair[0] + pair[1];
      } else if (cache.getSplitAxis == "vertical") {
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
      roomAreas.add(cache.getRoomArea);
      return roomAreas;
    } else {
      // 末端でなければ子階層を呼び出す。
      children.forEach((child) {
        roomAreas = child.getRoomAreas(roomAreas);});
    }
    return roomAreas;
  }


  void traceInfo(){
    print("#########################\n"
        "PRTITION INFO\n"
        "Root: ${cache.getIsRoot}, depth: ${cache.getDepth}/${cache.getSplitDepth}, Debug: ${cache.getIsDebug}\n"
        "name: ${cache.getName}, Split axis: ${cache.getSplitAxis} (bias: ±${cache.getSplitAxisBias}), Sprit ratio: ${cache.getSplitRatio} (bias: ±${cache.getSplitRatioBias})\n"
    );
    Util().trace2d(cache.getRect);
    if(children.isNotEmpty) {
      children.forEach((child) {child.traceInfo();});
    }
  }

  void acceptPartitionVisitor(PartitionVisitor visitor){
    visitor.storeData(this);
    if (depth < 3){
      children = visitor.createChildren(depth);
      children.forEach((child) {visitor.visit(child);});
      //children.map((child) => visitor.visit(child));
    }
  }

  void acceptRoomCreatorVisitor(RoomCreatorVisitor visitor){
    visitor.createRoomIfIsEdge(this);
  }

  Partition.initialize({required this.depth}){
    id = Random().nextInt(100);
  }

  Partition({required this.depth, required isRoot, required List<List<int>> rect, required String name}) {
    cache.rect = rect;
    cache.isRoot = isRoot;
    cache.name = name;
    depth += 1;
    createChildren();
  }
}