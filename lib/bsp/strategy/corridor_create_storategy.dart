import 'package:push_puzzle/bsp/strategy/strategy.dart';

import 'mst_strategy.dart';


class CorridorCreateStrategy extends Strategy {
  late List<Edge> edge;


  @override
  void execute() {
    }

  @override
  void trace() {
    logging.info("edge: $edge");
  }
  CorridorCreateStrategy({required super.material});
}