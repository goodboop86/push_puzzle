import 'dart:math';

class DungeonConfig {
  late int dungeonHeight;
  late int dungeonWidth;
  late int minMapSize;
  final int splitDepth = 3;

  DungeonConfig(
      {required this.dungeonHeight,
        required this.dungeonWidth,
        required this.minMapSize});
}