
import 'dart:math';

import 'package:push_puzzle/utility/bsp/area.dart';
import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/Tracer.dart';
import 'package:push_puzzle/utility/bsp/visitor.dart';

class RoomCreatorVisitor extends Visitor {
  late DungeonConfig config = DungeonConfig();

  late int gridHeight;
  late int gridWidth;
  // temporal partition
  late Partition tp;

  void visit(Partition partition){
    partition.acceptRoomCreatorVisitor(this);

  }

  void createRoomIfIsEdge(Partition p) {
    // コードの可読性を上げるため、処理が終わるまで格納する。
    // 実装として良いかは微妙
    tp = p;
    
    // 末端のnodeを指定して生成する必要がある.
    if(tp.children.isEmpty) {
      tp.cache.rect =  drawAreas();

      // 後のMSTで通路を決める際に利用
      // repo.roomArea = roomCreator.getRoomArea;
    } else {
      // 末端でなければ子階層を呼び出す。
      tp.children.forEach((child) {
        createRoomIfIsEdge(child);});
    }
  }

  bool isCreatable(List<List<int>> leaf) {
    int leafHeight = leaf.length;
    int leafWidth = leaf.first.length;

    // グリッドサイズ: 部屋を作成できる空間
    gridHeight = leafHeight - config.minMarginBetweenLeaf * 2;
    gridWidth = leafWidth - config.minMarginBetweenLeaf * 2;

    // 作成する部屋のサイズが小さすぎないか
    bool isEnoughRoomSize =
    (gridWidth > config.minRoomSize) && (gridHeight > config.minRoomSize) ? true : false;

    return  isEnoughRoomSize;
  }


  List<List<int>> drawAreas(){
    List<List<int>> leaf = tp.cache.getRect;
    if(isCreatable(leaf)) {
      // 最小部屋サイズが4、グリッドサイズ20なら 4~10になる
      int rh = Random().nextInt(gridHeight - config.minRoomSize) +
          config.minRoomSize; // roomHeight
      int rw = Random().nextInt(gridWidth - config.minRoomSize) +
          config.minRoomSize; // roomWidth

      // 部屋とグリッドとの距離をランダムに決める
      int hb = Random().nextInt(gridHeight - rh); // heightBias
      int wb = Random().nextInt(gridWidth - rw); // widthBias


      // グリッドを描画する範囲
      tp.cache.gridArea = Area(
          from: Point(y: config.minMarginBetweenLeaf, x: config.minMarginBetweenLeaf),
          to: Point(y: leaf.length - config.minMarginBetweenLeaf -1, x: leaf.first.length - config.minMarginBetweenLeaf -1));

      // UpdateAres
      // 部屋を描画する範囲
      tp.cache.roomArea = Area(
          from: Point(y: config.minMarginBetweenLeaf + hb, x: config.minMarginBetweenLeaf + wb),
          to: Point(y: config.minMarginBetweenLeaf + hb + rh -1, x: config.minMarginBetweenLeaf + wb + rw -1));

      for (int y = 0; y < leaf.length; y++) {
        for (int x = 0; x < leaf.first.length; x++) {
          if (tp.cache.getGridArea.isIn(y, x)){
            leaf[y][x] = 1;
            if (tp.cache.getRoomArea.isIn(y, x)) {
              leaf[y][x] = 4;
            }
          }
        }
      }

      print("roomHeight: $rh, roomWidth: $rw");
      CacheTracer u = CacheTracer();
      u.trace2d(leaf);

      return leaf;
    } else {
      Exception();
      return leaf;
    }
  }

  RoomCreatorVisitor();
}