import 'package:push_puzzle/bsp/strategy/mst.dart';
import 'package:push_puzzle/bsp/processor/processor.dart';
import 'package:push_puzzle/bsp/strategy/strategy_executor.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';

class ContextProcessor extends Processor {
  late ({List<Partition> leafs, List<List<int>> field}) context;

  @override
  void process() {
    ContextExecutor executor = ContextExecutor();

    ({List<Partition> partition ,List<Edge> edge}) edges = executor.execute(MSTStrategy(leafs: context.leafs, field: context.field));

    print(edges);

  }
  ContextProcessor({required this.context});
  // NOTE: contextをすぐ作り替えたいので、メンバ変数として持つのは微妙...
}