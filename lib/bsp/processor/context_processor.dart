import 'package:push_puzzle/bsp/mst/mst.dart';
import 'package:push_puzzle/bsp/processor/processor.dart';
import 'package:push_puzzle/bsp/strategy/corridor_create_storategy.dart';
import 'package:push_puzzle/bsp/strategy/strategy_executor.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';

class ContextProcessor extends Processor {
  late ({List<Partition> leafs, List<List<int>> field}) context;

  @override
  void process() {
    ContextExecutor executor = ContextExecutor();

    List<Edge> edges = executor.execute(CorridorCreateStrategy(leafs: context.leafs, field: context.field));

  }
  ContextProcessor({required this.context});
}