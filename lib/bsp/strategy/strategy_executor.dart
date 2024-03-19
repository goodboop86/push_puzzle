import 'package:push_puzzle/bsp/strategy/strategy.dart';

class ContextExecutor {

  execute(Strategy strategy) {
    return strategy.execute();
  }
  ContextExecutor();
}