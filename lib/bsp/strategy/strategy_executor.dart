import 'package:logging/logging.dart';
import 'package:push_puzzle/bsp/strategy/strategy.dart';

class StrategyExecutor {
  Logger logging = Logger("StrategyExecutor");

  execute(Strategy strategy) {
    logging.info("##### ${strategy.toString()}");
    return strategy.execute();
  }

  StrategyExecutor();
}
