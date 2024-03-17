import 'package:push_puzzle/algorithm/structure/partition.dart';
import 'package:push_puzzle/algorithm/visitor/visitor.dart';
import 'package:push_puzzle/algorithm/extention/list2d_extention.dart';

class PartitionLeafAccessorVisitor extends Visitor {
  @override
  List<Partition> visit(Partition partition, {bool isDebug = false}) {
    this.isDebug = isDebug;
    return partition.acceptLeafAccessorVisitor(this);
  }

  @override
  List<Partition> execute(Partition p) {
    List<Partition> leafs = [];
    if (shouldExecute(p)) {
      for (Partition child in p.children) {
        leafs = leafs + execute(child);
      }
      return leafs;
    } else {
      isDebug ? trace(p) : null;
      return [p];
    }
  }

  @override
  bool shouldExecute(Partition p) {
    return p.children.isNotEmpty;
  }

  @override
  void trace(Partition p) {
    logging
        .info("Root: ${p.isRoot}, depth: ${p.depth}/${p.config.dungeonDepth}, "
            "Debug: $isDebug "
            "name: ${p.name}, Split axis: ${p.getSplitAxis} "
            "(bias: ±${p.getSplitAxisBias}), Sprit ratio: ${p.getSplitRatio} "
            "(bias: ±${p.getSplitRatioBias}) "
            "absArea: ${p.absArea.toString()}");
    List<List<int>> rect = p.rect;
    rect.debugPrint();
  }

  PartitionLeafAccessorVisitor({required config}) : super(config);
}
