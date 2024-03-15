import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition/partition.dart';
import 'package:push_puzzle/utility/bsp/visitor/visitor.dart';
import 'package:push_puzzle/utility/bsp/extention/list2d_extention.dart';

class PartitionCreatorVisitor extends Visitor {
  late DungeonConfig config = DungeonConfig();
  late Partition tp;

  @override
  void visit(Partition partition, {bool isDebug = false}) {
    this.isDebug = isDebug;
    partition.acceptPartitionVisitor(this);
  }

  @override
  void execute(Partition p) {
    // コードの可読性を上げるため、処理が終わるまで格納する。
    // 実装として良いかは微妙
    tp = p;
    tp.children = [];
    // 分割回数が十分でないならchildrenの作成を繰り返す
    if (_isCreateChildren()) {
      List<List<List<int>>> pair = _split();
      tp.cache.depth = tp.depth;

      pair.asMap().forEach((int i, var leaf) {
        tp.cache.leafNumber = i;
        tp.children.add(Partition(
            rect: leaf, depth: tp.depth + 1, isRoot: false,
            name: tp.cache.getName + tp.cache.getLeafPosition()));
      });
    } else {
      tp.cache.depth = tp.depth;
    }

    isDebug? _trace() : null;
    for (var child in tp.children) {execute(child);}
  }


  // 2次元配列をパラメータに従って分割する。
  List<List<List<int>>> _split() {

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

  bool _isCreateChildren() {
    bool isShouldCreate = tp.depth < tp.cache.getSplitDepth ? true : false;

    // - 分割可能かはsplit()で利用するsublistへ渡すindexによって代わる
    // - sublistはsublist(0,0)などでも空配列を返せるのでexceptionはしない
    // - なので判定はisEmptyで良いが要素数1の場合にloopが続くので1以上が良さそう
    // memo: min(splitRatio)=biasなので、index境界は bias * 縦or横幅の四捨五入
    // biasが0.3、幅3ならindex境界は0.9->1となりsublist(0,1), sublist(1,3)が成立する
    bool isCreatable = tp.cache.getRect.length > 1;

    return isShouldCreate && isCreatable;
  }

  void _trace() {
    logging.info(
        "Root: ${tp.cache.getIsRoot}, depth: ${tp.cache.depth}/${tp.cache.getSplitDepth}, "
            "Debug: ${tp.cache.getIsDebug} "
            "name: ${tp.cache.getName}, Split axis: ${tp.cache.getSplitAxis} "
            "(bias: ±${tp.cache.getSplitAxisBias}), Sprit ratio: ${tp.cache.getSplitRatio} "
            "(bias: ±${tp.cache.getSplitRatioBias})"
    );
    List<List<int>> rect = tp.cache.getRect;
    rect.debugPrint();
  }

  PartitionCreatorVisitor();
}