import 'package:logging/logging.dart';
import 'package:push_puzzle/bsp/strategy/strategy_material.dart';

abstract class Strategy {
  Logger logging = Logger("Strategy");
  StrategyMaterial material;

  execute();
  trace();

  Strategy({required this.material});
}