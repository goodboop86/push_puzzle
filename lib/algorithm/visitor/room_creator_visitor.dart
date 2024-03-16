import 'dart:math';

import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/visitor.dart';
import 'package:push_puzzle/algorithm/extention/list2d_extention.dart';

class RoomCreatorVisitor extends Visitor {
  @override
  void visit(Partition partition, {bool isDebug = false}) {
    this.isDebug = isDebug;
    partition.acceptRoomCreatorVisitor(this);
  }

  @override
  void execute(Partition p) {
    // 末端のnodeを指定して生成する必要がある.
    if (p.children.isEmpty) {
      if (shouldExecute(p)) {
        p.rect = drawAreas(p);
      } else {
        logging.info("部屋を作成できるスペースがありません。");
      }

      // 後のMSTで通路を決める際に利用
      // repo.roomArea = roomCreator.getRoomArea;
    } else {
      // 末端でなければ子階層を呼び出す。
      for (var child in p.children) {
        execute(child);
      }
    }
  }

  @override
  bool shouldExecute(Partition p) {
    // グリッドサイズ: 部屋を作成できる空間
    //({int height, int width}) gridShape;

    ({int height, int width}) gridShape = (
      height: (p.rect.length - config.minMarginBetweenLeaf * 2).toInt(),
      width: (p.rect.first.length - config.minMarginBetweenLeaf * 2).toInt()
    );

    // gridHeight =  p.rect.length - config.minMarginBetweenLeaf * 2;
    // gridWidth = p.rect.first.length - config.minMarginBetweenLeaf * 2;

    // 作成する部屋のサイズが小さすぎないか
    bool isEnoughRoomSize = (gridShape.width > config.minRoomSize) &&
            (gridShape.height > config.minRoomSize)
        ? true
        : false;

    return isEnoughRoomSize;
  }

  List<List<int>> drawAreas(Partition p) {
    ({int height, int width}) gridShape = (
      height: (p.rect.length - config.minMarginBetweenLeaf * 2).toInt(),
      width: (p.rect.first.length - config.minMarginBetweenLeaf * 2).toInt()
    );

    List<List<int>> leaf = p.rect;
    // 最小部屋サイズが4、グリッドサイズ20なら 4~10になる
    int rh = Random().nextInt(gridShape.height - config.minRoomSize) +
        config.minRoomSize; // roomHeight
    int rw = Random().nextInt(gridShape.width - config.minRoomSize) +
        config.minRoomSize; // roomWidth

    // 部屋とグリッドとの距離をランダムに決める
    int hb = Random().nextInt(gridShape.height - rh); // heightBias
    int wb = Random().nextInt(gridShape.width - rw); // widthBias

    // グリッドを描画する範囲
    p.gridArea = Area(
        from: Point(
            y: config.minMarginBetweenLeaf, x: config.minMarginBetweenLeaf),
        to: Point(
            y: leaf.length - config.minMarginBetweenLeaf - 1,
            x: leaf.first.length - config.minMarginBetweenLeaf - 1));

    // UpdateAres
    // 部屋を描画する範囲
    p.roomArea = Area(
        from: Point(
            y: config.minMarginBetweenLeaf + hb,
            x: config.minMarginBetweenLeaf + wb),
        to: Point(
            y: config.minMarginBetweenLeaf + hb + rh - 1,
            x: config.minMarginBetweenLeaf + wb + rw - 1));

    for (int y = 0; y < leaf.length; y++) {
      for (int x = 0; x < leaf.first.length; x++) {
        if (p.getGridArea.isIn(y, x)) {
          leaf[y][x] = 1;
          if (p.getRoomArea.isIn(y, x)) {
            leaf[y][x] = 4;
          }
        }
      }
    }

    // grid, roomのabsAreaがMSTのために必要
    // そのために、このpartitionの絶対座標(from)を加算する
    p.absGridArea =
        p.getGridArea.add(Point(y: p.absArea.from.y, x: p.absArea.from.x));
    p.absRoomArea =
        p.getRoomArea.add(Point(y: p.absArea.from.y, x: p.absArea.from.x));

    isDebug ? trace(p) : null;
    return leaf;
  }

  @override
  void trace(Partition p) {
    logging.info("Root: ${p.isRoot}, depth: ${p.depth}/${p.getSplitDepth}, "
        "Debug: ${p.getIsDebug} "
        "name: ${p.name}, Split axis: ${p.getSplitAxis} "
        "(bias: ±${p.getSplitAxisBias}), Sprit ratio: ${p.getSplitRatio} "
        "(bias: ±${p.getSplitRatioBias}) "
        "absGridArea: ${p.getAbsGridArea.toString()}, "
        "absRoomArea: ${p.getAbsRoomArea.toString()}");
    List<List<int>> rect = p.rect;
    rect.debugPrint();
  }

  RoomCreatorVisitor({required config}) : super(config);
}
