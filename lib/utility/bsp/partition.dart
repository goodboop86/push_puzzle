// 再帰構造を持つツリークラス
import 'dart:math';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/util.dart';

class PartitionRepository {
  final double splitAxisBias = 0.1;
  final double splitRatioBias = 0.25;
  final Util u = Util();
  late String _splitAxis;
  late double _splitRatio;
  late int _depth;
  late int _leafNumber;

  set setSplitAxis(String splitAxis) {_splitAxis = splitAxis;}
  set setSplitRatio(double splitRatio) {_splitRatio = splitRatio;}
  set setDepth(int depth) {_depth = depth;}
  set setLeafNumber(int leafNumber) {_leafNumber = leafNumber;}

  get getSplitAxis => _splitAxis;
  get getSplitRatio => _splitRatio;
  get getDepth => _depth;
  get getLeafNumber => _leafNumber;

  void trace3d(_) => u.trace3d(_);

  void traceLeafWithInfo(List<List<int>> child) {
    String type = "";
    if (getSplitAxis=="vertical") {
      if(getLeafNumber == 0) {type="L";}
      if(getLeafNumber == 1) {type="R";}
    } else if(getSplitAxis=="horizontal") {
      if(getLeafNumber == 0) {type="U";}
      if(getLeafNumber == 1) {type="D";}
    }
    print("SplitAxis: $getSplitAxis, SplitRatio: $getSplitRatio, leafPosition: $type");
    u.trace2d(child);
    print("---");
  }
}

class Partition {
  late DungeonConfig config;
  late List<List<int>> rect;
  late List<Partition> children;
  late int depth;
  PartitionRepository info = PartitionRepository();


  // 長方形を分割する方向を決める。
  // ectのy/x比率 (± bias) > 1以上なら縦長なのでhorizontalに分割する。
  String getSplitAxisWithUpdateInfo(){
    info.setSplitAxis = (rect.length/rect.first.length) + (Random().nextDouble() * info.splitAxisBias) > 1 ? "horizontal" : "vertical";
    return info.getSplitAxis;
  }

  // 長方形を分割する比率を決める。
  double getSplitRatioWithUpdateInfo(){
    info.setSplitRatio = Random().nextDouble() / 2 + info.splitRatioBias;
    return info.getSplitRatio;
  }

  // 2次元配列をパラメータに従って分割する。
  List<List<List<int>>> split() {
    int height = rect.length;
    int width = rect.first.length;
    String axis = getSplitAxisWithUpdateInfo();
    double ratio = getSplitRatioWithUpdateInfo();

    List<List<List<int>>>? both = [];

    if (axis == "horizontal") {
      int idx = (height * ratio).toInt();

      // memo: sublistの第２引数の配列番号は含まれない
      both = [
        rect.sublist(0, idx),
        rect.sublist(idx, height)
      ];
    } else if (axis == "vertical") {
      int idx = (width * ratio).toInt();
      both = [
        rect.map((row) => row.sublist(0, idx)).toList(),
        rect.map((row) => row.sublist(idx, width)).toList()
      ];
    }

    // splitが作成されていなければexception(無い想定)
    if (both.isEmpty) {
      throw Exception();
    } else {
      return both;
    }
  }

  bool isCreateChildren() {
    bool isShouldCreate = depth < config.splitDepth ? true : false;

    // - 分割可能かはsplit()で利用するsublistへ渡すindexによって代わる
    // - sublistはsublist(0,0)などでも空配列を返せるのでexceptionはしない
    // - なので判定はisEmptyで良いが要素数1の場合にloopが続くので1以上が良さそう
    // memo: min(splitRatio)=biasなので、index境界は bias * 縦or横幅の四捨五入
    // biasが0.3、幅3ならindex境界は0.9->1となりsublist(0,1), sublist(1,3)が成立する
    bool isCreatable = rect.length > 1;

    return isShouldCreate && isCreatable;
  }

  void createChildren() {
    // 分割回数が十分でないならchildrenの作成を繰り返す
    if (isCreateChildren()) {
      List<List<List<int>>> leaf = split();

      info.setDepth = depth;

      // children = leaf.map((half) => Partition(config: config, rect: half, depth: depth)).toList();
      leaf.asMap().forEach((int i, var child) {
        info.setLeafNumber = i;
        print("#####$i#####");
        info.traceLeafWithInfo(child);
        Partition(config: config, rect: child, depth: depth);
      });
    } else{
      children = [];
    }
  }

  Partition({required this.config, required this.rect, required this.depth}) {
    depth += 1;
    createChildren();
  }

}