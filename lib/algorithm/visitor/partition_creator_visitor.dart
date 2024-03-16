import 'dart:math';

import 'package:push_puzzle/algorithm/area.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/visitor.dart';
import 'package:push_puzzle/algorithm/extention/list2d_extention.dart';
import 'package:push_puzzle/algorithm/visitor/visitor_config.dart';

class PartitionCreatorVisitor extends Visitor {
  late PartitionCreatorAdjustor adjustor;

  @override
  void visit(Partition partition, {bool isDebug = false}) {
    this.isDebug = isDebug;
    partition.acceptPartitionCreatorVisitor(this);
  }

  @override
  void execute(Partition p) {
    p.children = [];
    // 分割回数が十分でないならchildrenの作成を繰り返す
    if (shouldExecute(p)) {
      var data = _split(p);
      List<List<List<int>>> pair = data.pair;
      List<Area> absArea = data.absArea;

      p.depth = p.depth;

      pair.asMap().forEach((int i, var leaf) {
        p.leafNumber = i;
        p.children.add(Partition(
            rect: leaf,
            depth: p.depth + 1,
            isRoot: false,
            absArea: absArea[i],
            name: p.name + getLeafPosition(p),
            config: config));
      });
    } else {
      p.depth = p.depth;
    }

    isDebug ? trace(p) : null;
    for (var child in p.children) {
      execute(child);
    }
  }

  // [for partitionCreatorVisitor]
  String getLeafPosition(Partition p) {
    String type = "";
    if (p.getSplitAxis == "vertical") {
      if (p.getLeafNumber == 0) {
        type = "L";
      }
      if (p.getLeafNumber == 1) {
        type = "R";
      }
    } else if (p.getSplitAxis == "horizontal") {
      if (p.getLeafNumber == 0) {
        type = "U";
      }
      if (p.getLeafNumber == 1) {
        type = "D";
      }
    }
    return type;
  }


  // 2次元配列をパラメータに従って分割する。
  ({List<List<List<int>>> pair, List<Area> absArea}) _split(Partition p) {
    List<List<int>> rect = p.rect;
    int height = rect.length;
    int width = rect.first.length;
    p.splitAxis = adjustor.adjustSplitAxis(p);
    String axis = p.getSplitAxis;
    p.splitRatio = adjustor.adjustSplitRatio(p);
    double ratio = p.getSplitRatio;

    List<Area> absAreas = [];
    List<List<List<int>>> pair = [];
    if (axis == "horizontal") {
      int idx = (height * ratio).toInt();
      // memo: sublistの第２引数の配列番号は含まれない
      pair = [rect.sublist(0, idx), rect.sublist(idx, height)];
      absAreas = [
        Area(from: Point(y: 0, x: 0), to: Point(y: idx - 1, x: width - 1)),
        Area(from: Point(y: idx, x: 0), to: Point(y: height - 1, x: width - 1)),
      ];
    } else if (axis == "vertical") {
      int idx = (width * ratio).toInt();
      pair = [
        rect.map((row) => row.sublist(0, idx)).toList(),
        rect.map((row) => row.sublist(idx, width)).toList()
      ];
      absAreas = [
        Area(from: Point(y: 0, x: 0), to: Point(y: height - 1, x: idx - 1)),
        Area(from: Point(y: 0, x: idx), to: Point(y: height - 1, x: width - 1)),
      ];
    }

    // splitが作成されていなければexception(無い想定)
    if (pair.isEmpty) {
      throw Exception("$PartitionCreatorVisitor");
    } else {
      ({List<List<List<int>>> pair, List<Area> absArea}) data =
      (pair: pair, absArea: absAreas);
      return data;
    }
  }

  @override
  bool shouldExecute(Partition p) {
    bool isShouldCreate = p.depth < p.config.dungeonDepth ? true : false;

    // - 分割可能かはsplit()で利用するsublistへ渡すindexによって代わる
    // - sublistはsublist(0,0)などでも空配列を返せるのでexceptionはしない
    // - なので判定はisEmptyで良いが要素数1の場合にloopが続くので1以上が良さそう
    // memo: min(splitRatio)=biasなので、index境界は bias * 縦or横幅の四捨五入
    // biasが0.3、幅3ならindex境界は0.9->1となりsublist(0,1), sublist(1,3)が成立する
    bool isCreatable = p.rect.length > 1;

    return isShouldCreate && isCreatable;
  }

  @override
  void trace(Partition p) {
    logging.info("Root: ${p.isRoot}, depth: ${p.depth}/${p.getSplitDepth}, "
        "Debug: ${p.getIsDebug} "
        "name: ${p.name}, Split axis: ${p.getSplitAxis} "
        "(bias: ±${p.getSplitAxisBias}), Sprit ratio: ${p.getSplitRatio} "
        "(bias: ±${p.getSplitRatioBias}) "
        "absArea: ${p.absArea.toString()}");
    List<List<int>> rect = p.rect;
    rect.debugPrint();
  }

  PartitionCreatorVisitor({required config, required this.adjustor})
      : super(config);
}

// テストのため切り出す
class PartitionCreatorAdjustor {

  // 長方形を分割する方向を決める。
  // ectのy/x比率 (± bias) > 1以上なら縦長なのでhorizontalに分割する。
  String adjustSplitAxis(Partition p) {
    return (p.rect.length / p.rect.first.length) +
        (Random().nextDouble() * p.getSplitAxisBias) >
        1
        ? "horizontal"
        : "vertical";
  }

  // 長方形を分割する比率を決める。
  double adjustSplitRatio(Partition p) {
    return Random().nextDouble() / 2 + p.getSplitRatioBias;
  }
}


