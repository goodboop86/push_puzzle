import 'package:push_puzzle/bsp/strategy/mst.dart';
import 'package:push_puzzle/bsp/strategy/strategy.dart';

class ContextExecutor {

  List<Edge> execute(Strategy strategy) {
    return strategy.execute();
  }
  ContextExecutor();
}