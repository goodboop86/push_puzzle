import 'dart:math';

import 'package:push_puzzle/bsp/area.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';
import 'package:push_puzzle/bsp/visitor/visitor.dart';
import 'package:push_puzzle/bsp/extention/list2d_extention.dart';

class RoomCreatorVisitor extends Visitor {
  late RoomCreatorAdjustor adjustor;
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

    p.gridShape = (
      height: (p.rect.length - config.minMarginBetweenLeaf * 2).toInt(),
      width: (p.rect.first.length - config.minMarginBetweenLeaf * 2).toInt()
    );

    // gridHeight =  p.rect.length - config.minMarginBetweenLeaf * 2;
    // gridWidth = p.rect.first.length - config.minMarginBetweenLeaf * 2;

    // 作成する部屋のサイズが小さすぎないか
    bool isEnoughRoomSize = (p.getGridShape.width > config.minRoomSize) &&
            (p.getGridShape.height > config.minRoomSize)
        ? true
        : false;

    return isEnoughRoomSize;
  }

  List<List<int>> drawAreas(Partition p) {
    List<List<int>> leaf = p.rect;
    // 最小部屋サイズが4、グリッドサイズ20なら 4~10になる
    p.roomShape = adjustor.getRoomShape(p); // roomWidth

    // 部屋とグリッドとの距離をランダムに決める
    ({int height, int width}) rbs = adjustor.getRoomBiasShape(p);

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
            y: config.minMarginBetweenLeaf + rbs.height,
            x: config.minMarginBetweenLeaf + rbs.width),
        to: Point(
            y: config.minMarginBetweenLeaf +
                rbs.height +
                p.roomShape.height -
                1,
            x: config.minMarginBetweenLeaf +
                rbs.width +
                p.roomShape.width -
                1));

    for (int y = 0; y < leaf.length; y++) {
      for (int x = 0; x < leaf.first.length; x++) {
        if (p.getGridArea.isIn(y, x)) {
          leaf[y][x] = 1;
          if (p.getRoomArea.isIn(y, x)) {
            leaf[y][x] = 2;
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

    p.hasGridArea = true;
    p.hasRoomArea = true;

    isDebug ? trace(p) : null;
    return leaf;
  }

  @override
  void trace(Partition p) {
    logging
        .info("Root: ${p.isRoot}, depth: ${p.depth}/${p.config.dungeonDepth}, "
            "Debug: ${p.getIsDebug} "
            "name: ${p.name}, Split axis: ${p.getSplitAxis} "
            "(bias: ±${p.getSplitAxisBias}), Sprit ratio: ${p.getSplitRatio} "
            "(bias: ±${p.getSplitRatioBias}) "
            "absGridArea: ${p.getAbsGridArea.toString()}, "
            "absRoomArea: ${p.absRoomArea.toString()}");
    List<List<int>> rect = p.rect;
    rect.debugPrint();
  }

  RoomCreatorVisitor({required config, required this.adjustor}) : super(config);
}

class RoomCreatorAdjustor {
  ({int height, int width}) getRoomShape(Partition p) {
    int rh = Random().nextInt(p.getGridShape.height - p.config.minRoomSize) +
        p.config.minRoomSize;
    int rw = Random().nextInt(p.getGridShape.width - p.config.minRoomSize) +
        p.config.minRoomSize;

    return (height: rh, width: rw);
  }

  ({int height, int width}) getRoomBiasShape(Partition p) {
    int hb = Random().nextInt(p.getGridShape.height - p.roomShape.height);
    int wb = Random().nextInt(p.getGridShape.width - p.roomShape.width);

    return (height: hb, width: wb);
  }
}
