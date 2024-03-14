import 'package:logging/logging.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/visitor.dart';
import 'package:push_puzzle/utility/bsp/extention/list2d_extention.dart';


class ConsolidatorVisitor extends Visitor {
  final log = Logger('ConsolidatorVisitor');
  late Partition tp;


  // FIXME: visitor パターンに移行途中。[not-working]
  @override
  void visit(Partition partition) {
    partition.acceptConsolidatorVisitor(this);
  }

  List<List<int>> consolid(Partition p){
    tp = p;
    bool isRoot = tp.cache.getIsRoot;
    bool isEdge = tp.children.isEmpty;
    if(isEdge) {
      tp.cache.consolidRect = tp.cache.getRect;
      return tp.cache.getRect;
    } else {
      //要素2
      List<List<List<int>>> pair =[];
      tp.children.forEach((child) {pair.add(consolid(child));});

      if (tp.cache.getSplitAxis == "horizontal") {
        return pair[0] + pair[1];
      } else if (tp.cache.getSplitAxis == "vertical") {
        List<List<int>> merged = [];
        for (int i = 0; i < pair[0].length; i++) {
          merged.addAll([pair[0][i] + pair[1][i]]);
        }
        tp.cache.consolidRect = merged;
        return merged;
      } else {
        // 無い想定
        Exception();
        tp.cache.consolidRect = [];
        return [];
      }
    }
  }

}