import 'dart:math';

class DungeonConfig {
  late int dungeonHeight;
  late int dungeonWidth;
  late int minMapSize;
  final double splitRatioBias = 0.2;
  // 0.3 ~ 0.7
  get splitRatio => Random().nextDouble() / 2 + splitRatioBias;
  // 1 ~ 4
  //get splitDepth => Random().nextInt(2) + 1;
  final int splitDepth = 5;

  DungeonConfig(
      {required this.dungeonHeight,
        required this.dungeonWidth,
        required this.minMapSize});
}