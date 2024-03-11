import 'dart:math';

class DungeonConfig {
  // ダンジョンの設定値
  final int dungeonHeight = 20;
  final int dungeonWidth = 15;

  // Partitionの設定値
  final int initialDepth = 0; //don't change
  final bool initialIsRoot = true; //don't change
  final String rootName = "r";

  // RoomCreatorの設定値
  final int minRoomSize = 4;
  final int minMarginBetweenLeaf = 2;
  final double gridRatio = 0.6;


}