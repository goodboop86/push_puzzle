import 'package:push_puzzle/bsp/visitor/corridor_creator_visitor.dart';
import 'package:push_puzzle/bsp/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/bsp/visitor/partition_leaf_accessor_visitor.dart';
import 'package:push_puzzle/bsp/visitor/visitor_config.dart';
import 'package:push_puzzle/bsp/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/bsp/visitor/room_creator_visitor.dart';
import 'package:logging/logging.dart';
import '../area.dart';

class Partition {
  final log = Logger('Partition');
  late VisitorConfig config;
  List<Partition> children = [];
  late int depth;

  // 初期設定値
  final double _splitRatioBias = 0.25;
  final bool _isDebug = false;
  late bool isRoot;

  // 共通設定
  late List<List<int>> rect;
  late Area absArea;
  String name = "";

  // createChildrenに関する設定
  late String _splitAxis = "";
  late double _splitRatio = -1;
  late int _leafNumber;
  final double _splitAxisBias = 0.1;

  // roomCreatorに関する設定
  late ({int height, int width}) _gridShape;
  late ({int height, int width}) roomShape;
  late Area _gridArea;
  late Area _roomArea;
  late Area _absGridArea;
  late Area absRoomArea;
  bool hasGridArea = false;
  bool hasRoomArea = false;

  // 結合に関する設定
  late List<List<int>> _arrangedRect;

  set leafNumber(int _) {
    _leafNumber = _;
  }

  set splitAxis(String _) {
    _splitAxis = _;
  }

  set splitRatio(double _) {
    _splitRatio = _;
  }

  set gridShape(({int height, int width}) _) => {_gridShape = _};
  set roomArea(Area _) => {_roomArea = _};
  set gridArea(Area _) => {_gridArea = _};
  set arrangedRect(var _) => {_arrangedRect = _};
  set absGridArea(Area _) => {_absGridArea = _};

  get getSplitAxisBias => _splitAxisBias;
  get getSplitRatioBias => _splitRatioBias;
  get getIsDebug => _isDebug;
  get getSplitAxis => _splitAxis;
  get getSplitRatio => _splitRatio;

  // roomCreatorに関する設定
  get getGridShape => _gridShape;
  get getRoomArea => _roomArea;
  get getGridArea => _gridArea;
  get getArrangedRect => _arrangedRect;
  get getAbsGridArea => _absGridArea;
  get getLeafNumber => _leafNumber;

  void acceptPartitionCreatorVisitor(PartitionCreatorVisitor visitor) {
    log.info("##### ${visitor.toString()}. depth: ${config.dungeonDepth}");
    visitor.execute(this);
  }

  void acceptRoomCreatorVisitor(RoomCreatorVisitor visitor) {
    log.info("##### ${visitor.toString()}. depth: ${config.dungeonDepth}");
    visitor.execute(this);
  }

  List<List<int>> acceptPartitionArrangerVisitor(PartitionArrangerVisitor visitor) {
    log.info("##### ${visitor.toString()}. depth: ${config.dungeonDepth}");
    // 各Treeの結合配列はそれぞれのcacheに格納されるので戻す必要はない。
    return visitor.execute(this);
  }

  List<Partition> acceptLeafAccessorVisitor(
      PartitionLeafAccessorVisitor visitor) {
    log.info("##### ${visitor.toString()}. depth: ${config.dungeonDepth}");
    // 各Treeの結合配列はそれぞれのcacheに格納されるので戻す必要はない。
    return visitor.execute(this);
  }

  void acceptCorridorCreatorVisitor(
      CorridorCreatorVisitor visitor) {
    log.info("##### ${visitor.toString()}. depth: ${config.dungeonDepth}");
    // 各Treeの結合配列はそれぞれのcacheに格納されるので戻す必要はない。
    visitor.execute(this);
  }

  Partition(
      {required this.depth,
      required this.isRoot,
      required this.rect,
      required this.absArea,
      required this.name,
      required this.config});
}
