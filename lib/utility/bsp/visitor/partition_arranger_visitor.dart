import 'package:push_puzzle/utility/bsp/partition/partition.dart';
import 'package:push_puzzle/utility/bsp/visitor/visitor.dart';
import 'package:push_puzzle/utility/bsp/extention/list2d_extention.dart';


class PartitionArrangerVisitor extends Visitor {

  @override
  void visit(Partition partition, {bool isDebug = false}) {
    this.isDebug = isDebug;
    partition.acceptConsolidatorVisitor(this);
  }

  @override
  List<List<int>> execute(Partition p) {
    // ここではtp=pとしない。tpは再帰呼び出しの最後のedgeの情報を持つため
    // 最後に返却された結合配列がrootに対する戻り値であるのに対しif文を通り抜けてしまう。

    if (p.children.isEmpty) {
      p.cache.consolidRect = p.cache.getRect;
      return p.cache.getConsolidRect;

    } else {
      //要素2
      List<List<List<int>>> pair = [];
      for (var child in p.children) {pair.add(execute(child));}

      List<List<int>> merged = [];
      if (p.cache.getSplitAxis == "horizontal") {
        merged =  pair[0] + pair[1];
      } else if (p.cache.getSplitAxis == "vertical") {
        for (int i = 0; i < pair[0].length; i++) {
          merged.addAll([pair[0][i] + pair[1][i]]);
        }
      } else {
        // 無い想定
        Exception();
        return [];
      }

      isDebug? _trace(p): null;
      p.cache.consolidRect = merged;
      return p.cache.getConsolidRect;
    }
  }

  void _trace(Partition p) {
    logging.info(
        "Root: ${p.cache.getIsRoot}, depth: ${p.cache.depth}/${p.cache.getSplitDepth}, "
            "Debug: ${p.cache.getIsDebug} "
            "name: ${p.cache.getName}, Split axis: ${p.cache.getSplitAxis} "
            "(bias: ±${p.cache.getSplitAxisBias}), Sprit ratio: ${p.cache.getSplitRatio} "
            "(bias: ±${p.cache.getSplitRatioBias})"
    );
    List<List<int>> rect = p.cache.getRect;
    rect.debugPrint();
  }

}