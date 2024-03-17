import 'package:push_puzzle/algorithm/visitor/visitor_config.dart';

class TestVisitorConfig extends VisitorConfig {
  // ダンジョンの設定値
  @override
  final int dungeonHeight = 20;
  @override
  final int dungeonWidth = 24;
  @override
  final int dungeonDepth = 2;

  // RoomCreatorの設定値
  @override
  final int minRoomSize = 3;
  @override
  final int minMarginBetweenLeaf = 2;
  @override
  final double gridRatio = 0.6;
}
