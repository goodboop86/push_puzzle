// 再帰構造を持つツリークラス
import 'dart:math';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';

class Partition {
  // 分割された長方形
  late DungeonConfig config;
  late List<List<int>> rect;
  late List<Partition> children;
  late int depth;
  final double splitAxisBias = 0.1;
  // rectのy/x比率 ± bias > 1以上なら縦長なのでhorizontalに分割する。
  get splitAxis => (rect.length/rect.first.length) + (Random().nextDouble() * splitAxisBias)  > 1 ? "horizontal" : "vertical";

  // 2次元配列をパラメータに従って分割する。
  List<List<List<int>>> split() {
    int height = rect.length;
    int width = rect.first.length;
    double ratio = config.splitRatio;
    String axis = splitAxis;

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
      List<List<List<int>>> both = split();
      children = both.map((half) => Partition(config: config, rect: half, depth: depth)).toList();
    } else{
      children = [];
    }
  }

  Partition({required this.config, required this.rect, required this.depth}) {
    depth += 1;
    createChildren();
  }
}