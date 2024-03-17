import 'package:push_puzzle/bsp/visitor/visitor_config.dart';

class TestVisitorConfig extends VisitorConfig {
  // ダンジョンの設定値
  @override
  final int dungeonHeight = 40;
  @override
  final int dungeonWidth = 40;
  @override
  final int dungeonDepth = 2;

  // RoomCreatorの設定値
  @override
  final int minRoomSize = 4;
  @override
  final int minMarginBetweenLeaf = 2;
}
