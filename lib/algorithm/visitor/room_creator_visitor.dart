
import 'dart:math';

import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/dungeon_config.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/visitor.dart';
import 'package:push_puzzle/algorithm/extention/list2d_extention.dart';

class RoomCreatorVisitor extends Visitor {
  late DungeonConfig config = DungeonConfig();

  late int gridHeight;
  late int gridWidth;

  @override
  void visit(Partition partition, {bool isDebug = false}){
    this.isDebug = isDebug;
    partition.acceptRoomCreatorVisitor(this);

  }

  @override
  void execute(Partition p) {

    // 末端のnodeを指定して生成する必要がある.
    if(p.children.isEmpty) {
      if(shouldExecute(p)) {
        p.cache.rect = drawAreas(p);
      } else {
        logging.info("部屋を作成できるスペースがありません。");
      }

      // 後のMSTで通路を決める際に利用
      // repo.roomArea = roomCreator.getRoomArea;
    } else {
      // 末端でなければ子階層を呼び出す。
      for (var child in p.children) {
        execute(child);}
    }
  }

  bool shouldExecute(Partition p) {
    List<List<int>> leaf = p.cache.getRect;
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


  List<List<int>> drawAreas(Partition p){
    List<List<int>> leaf = p.cache.getRect;
      // 最小部屋サイズが4、グリッドサイズ20なら 4~10になる
      int rh = Random().nextInt(gridHeight - config.minRoomSize) +
          config.minRoomSize; // roomHeight
      int rw = Random().nextInt(gridWidth - config.minRoomSize) +
          config.minRoomSize; // roomWidth

      // 部屋とグリッドとの距離をランダムに決める
      int hb = Random().nextInt(gridHeight - rh); // heightBias
      int wb = Random().nextInt(gridWidth - rw); // widthBias


      // グリッドを描画する範囲
      p.cache.gridArea = Area(
          from: Point(y: config.minMarginBetweenLeaf, x: config.minMarginBetweenLeaf),
          to: Point(y: leaf.length - config.minMarginBetweenLeaf -1, x: leaf.first.length - config.minMarginBetweenLeaf -1));

      // UpdateAres
      // 部屋を描画する範囲
      p.cache.roomArea = Area(
          from: Point(y: config.minMarginBetweenLeaf + hb, x: config.minMarginBetweenLeaf + wb),
          to: Point(y: config.minMarginBetweenLeaf + hb + rh -1, x: config.minMarginBetweenLeaf + wb + rw -1));

      for (int y = 0; y < leaf.length; y++) {
        for (int x = 0; x < leaf.first.length; x++) {
          if (p.cache.getGridArea.isIn(y, x)){
            leaf[y][x] = 1;
            if (p.cache.getRoomArea.isIn(y, x)) {
              leaf[y][x] = 4;
            }
          }
        }
      }

      // grid, roomのabsAreaがMSTのために必要
      // そのために、このpartitionの絶対座標(from)を加算する
      p.cache.absGridArea = p.cache.getGridArea.add(Point(y: p.cache.getAbsArea.from.y, x: p.cache.getAbsArea.from.x));
      p.cache.absRoomArea = p.cache.getRoomArea.add(Point(y: p.cache.getAbsArea.from.y, x: p.cache.getAbsArea.from.x));

      isDebug? _trace(p): null;
      return leaf;
  }

  void _trace(Partition p) {
    logging.info(
        "Root: ${p.cache.getIsRoot}, depth: ${p.cache.depth}/${p.cache.getSplitDepth}, "
            "Debug: ${p.cache.getIsDebug} "
            "name: ${p.cache.getName}, Split axis: ${p.cache.getSplitAxis} "
            "(bias: ±${p.cache.getSplitAxisBias}), Sprit ratio: ${p.cache.getSplitRatio} "
            "(bias: ±${p.cache.getSplitRatioBias}) "
            "absGridArea: ${p.cache.getAbsGridArea.toString()}, "
            "absRoomArea: ${p.cache.getAbsRoomArea.toString()}"
    );
    List<List<int>> rect = p.cache.getRect;
    rect.debugPrint();
  }

  RoomCreatorVisitor();
}