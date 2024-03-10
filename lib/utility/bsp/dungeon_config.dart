import 'dart:math';

class DungeonConfig {
  late int dungeonHeight = 15;
  late int dungeonWidth = 10;
  late int minMapSize = 4;

  DungeonConfig(
      {required this.dungeonHeight,
        required this.dungeonWidth,
        required this.minMapSize});
}