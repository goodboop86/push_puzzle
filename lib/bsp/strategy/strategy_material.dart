import 'package:logging/logging.dart';
import 'package:push_puzzle/bsp/extention/list2d_extention.dart';
import 'package:push_puzzle/bsp/strategy/mst_strategy.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';

class StrategyMaterial {
  Logger logging = Logger("StrategyMaterial");
  late List<Partition> leafs;
  late List<List<int>> field;
  late List<Edge> edges;
  StrategyMaterial({required this.leafs, required this.field, required this.edges});

  trace() {
    logging.info("leafs: $leafs edge: $edges");
    field.debugField();
  }
}