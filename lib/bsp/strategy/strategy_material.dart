import 'package:logging/logging.dart';
import 'package:push_puzzle/bsp/strategy/mst_strategy.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';

class StrategyMaterial {
  Logger logging = Logger("StrategyMaterial");
  late List<Partition> leafs;
  late List<List<int>> field;
  late List<Edge> edge;
  StrategyMaterial({required this.leafs, required this.field, required this.edge});

  trace() {
    logging.info("leafs: $leafs \nfield: $field \nedge: $edge");
  }
}