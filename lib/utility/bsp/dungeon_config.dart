import 'dart:math';

class DungeonConfig {
  late int dungeonHeight;
  late int dungeonWidth;
  late int minMapSize;
  // 0.25 ~ 0.75
  get splitRatio => Random().nextDouble() / 2 + 0.25;
  get splitAxis => Random().nextBool() ? "horizontal" : "vertical";

  DungeonConfig(
      {required this.dungeonHeight,
        required this.dungeonWidth,
        required this.minMapSize});
}