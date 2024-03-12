import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/visitor.dart';

class PartitionVisitor extends Visitor {
  late DungeonConfig config = DungeonConfig();
  late Partition tp;

  @override
  void visit(Partition partition) {
    partition.acceptPartitionVisitor(this);
  }


  void createChildren(Partition p) {
    // コードの可読性を上げるため、処理が終わるまで格納する。
    // 実装として良いかは微妙
    tp = p;

    tp.children = [];
    // 分割回数が十分でないならchildrenの作成を繰り返す
    if (isCreateChildren()) {
      List<List<List<int>>> pair = split();
      tp.cache.depth = tp.depth;

      pair.asMap().forEach((int i, var leaf) {
        tp.cache.leafNumber = i;
        tp.cache.traceLeafWithInfo(leaf);
        tp.children.add(Partition(
            rect: leaf, depth: tp.depth, isRoot: false,
            name: tp.cache.getName + tp.cache.getLeafPosition()));
      });
    } else {
      tp.cache.depth = tp.depth;
    }

    tp.children.forEach((child) {createChildren(child);});
  }


  // 2次元配列をパラメータに従って分割する。
  List<List<List<int>>> split() {

    List<List<int>> rect = tp.cache.getRect;
    int height = rect.length;
    int width = rect.first.length;
    tp.cache.adjustSplitAxis();
    String axis = tp.cache.getSplitAxis;
    tp.cache.adjustSplitRatio();
    double ratio = tp.cache.getSplitRatio;

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
    bool isShouldCreate = tp.depth < tp.cache.getSplitDepth ? true : false;

    // - 分割可能かはsplit()で利用するsublistへ渡すindexによって代わる
    // - sublistはsublist(0,0)などでも空配列を返せるのでexceptionはしない
    // - なので判定はisEmptyで良いが要素数1の場合にloopが続くので1以上が良さそう
    // memo: min(splitRatio)=biasなので、index境界は bias * 縦or横幅の四捨五入
    // biasが0.3、幅3ならindex境界は0.9->1となりsublist(0,1), sublist(1,3)が成立する
    bool isCreatable = tp.cache.getRect.length > 1;

    return isShouldCreate && isCreatable;
  }

  PartitionVisitor();
}

void main() {
  DungeonConfig d = DungeonConfig();
  List<List<int>> initialRect = List.generate(d.dungeonHeight,
          (i) => List.generate(d.dungeonWidth, (j) => 8));
  Partition partition = Partition.construct(
      depth: d.initialDepth, isRoot: d.initialIsRoot, rect: initialRect, name: d.rootName);
  PartitionVisitor visitor = PartitionVisitor();
  visitor.visit(partition);
  print("end");
}