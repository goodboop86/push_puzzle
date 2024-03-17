class DungeonConfig {
  // ダンジョンの設定値
  final int dungeonHeight = 10;
  final int dungeonWidth = 10;
  final int dungeonDepth = 3;

  // Partitionの設定値
  final int initialDepth = -0; //don't change
  final bool initialIsRoot = true; //don't change
  final String rootName = "r"; // don't change

  // RoomCreatorの設定値
  final int minRoomSize = 4;
  final int minMarginBetweenLeaf = 2;
  final double gridRatio = 0.6;
}
