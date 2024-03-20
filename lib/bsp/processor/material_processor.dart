import 'package:push_puzzle/bsp/strategy/corridor_create_storategy.dart';
import 'package:push_puzzle/bsp/strategy/mst_strategy.dart';
import 'package:push_puzzle/bsp/processor/processor.dart';
import 'package:push_puzzle/bsp/strategy/strategy.dart';
import 'package:push_puzzle/bsp/strategy/strategy_executor.dart';
import 'package:push_puzzle/bsp/strategy/strategy_material.dart';

class MaterialProcessor extends Processor {
  late StrategyMaterial material;
  late Strategy strategy;
  StrategyExecutor executor = StrategyExecutor();

  @override
  void process() {

    List<StrategyType> order = [
      StrategyType.MST,
      StrategyType.CORRIDOR_CREATE
    ];

    for (var strategyType in order) {
      switch (strategyType) {
        case StrategyType.MST:
          strategy = MSTStrategy(material: material);
          break;
        case StrategyType.CORRIDOR_CREATE:
          strategy = CorridorCreateStrategy(material: material);
          break;
      }
      material = executor.execute(strategy);
      material.trace();
    }

    print(material);



    //print(target);

  }
  MaterialProcessor({required this.material});
  // NOTE: contextをすぐ作り替えたいので、メンバ変数として持つのは微妙...
}

enum StrategyType{
  MST,
  CORRIDOR_CREATE
}