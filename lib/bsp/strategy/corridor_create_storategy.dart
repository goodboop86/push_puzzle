import 'package:push_puzzle/bsp/strategy/strategy.dart';

import 'mst_strategy.dart';


class CorridorCreateStrategy extends Strategy {


  @override
  void execute() {;
    }

  @override
  void trace() {
    logging.info("==== \nCorridorCreateStrategy");
  }
  CorridorCreateStrategy({required super.material});
}