import 'package:push_puzzle/bsp/structure/partition.dart';

abstract class Strategy {
  List<Partition> leafs;
  List<List<int>> field;

  execute();

  Strategy({required this.leafs, required this.field});
}