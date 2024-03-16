import 'dart:math';

import 'package:push_puzzle/algorithm/visitor/partition_arranger_visitor.dart';
import 'package:push_puzzle/algorithm/dungeon_config.dart';
import 'package:push_puzzle/algorithm/visitor/partition_creator_visitor.dart';
import 'package:push_puzzle/algorithm/visitor/room_creator_visitor.dart';
import 'package:logging/logging.dart';
import '../area.dart';


class Partition {
  final log = Logger('Partition');
  final DungeonConfig config = DungeonConfig();
  List<Partition> children = [];
  late int depth;

  // 初期設定値
  final double _splitRatioBias = 0.25;
  final int _splitDepth = 3;
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
  late Area _gridArea;
  late Area _roomArea;
  late Area _absGridArea;
  late Area _absRoomArea;

  // 結合に関する設定
  late List<List<int>> _arrangedRect;


  set leafNumber(int _) {_leafNumber = _;}
  set roomArea(Area _) => {_roomArea = _};
  set gridArea(Area _) => {_gridArea = _};
  set arrangedRect(var _) => {_arrangedRect = _};
  set absGridArea(Area _) => {_absGridArea = _};
  set absRoomArea(Area _) => {_absRoomArea = _};

  get getSplitAxisBias => _splitAxisBias;
  get getSplitRatioBias => _splitRatioBias;
  get getSplitDepth => _splitDepth;
  get getIsDebug => _isDebug;
  get getSplitAxis => _splitAxis;
  get getSplitRatio => _splitRatio;

  // roomCreatorに関する設定
  // get getDepth => _depth;
  get getRoomArea => _roomArea;
  get getGridArea => _gridArea;
  get getArrangedRect => _arrangedRect;
  get getAbsGridArea => _absGridArea;
  get getAbsRoomArea => _absRoomArea;


  // [for partitionCreatorVisitor]
  String getLeafPosition(){
    String type = "";
    if (_splitAxis=="vertical") {
      if(_leafNumber == 0) {type="L";}
      if(_leafNumber == 1) {type="R";}
    } else if(_splitAxis=="horizontal") {
      if(_leafNumber == 0) {type="U";}
      if(_leafNumber == 1) {type="D";}
    }
    return type;
  }


  // 長方形を分割する方向を決める。
  // ectのy/x比率 (± bias) > 1以上なら縦長なのでhorizontalに分割する。
  void adjustSplitAxis() {
    _splitAxis =  (rect.length/rect.first.length) + (Random().nextDouble() * _splitAxisBias) > 1 ? "horizontal" : "vertical";
  }

  // 長方形を分割する比率を決める。
  void adjustSplitRatio() {
    _splitRatio =  Random().nextDouble() / 2 + _splitRatioBias;
  }


  void acceptPartitionCreatorVisitor(PartitionCreatorVisitor visitor){
      log.info("##### Create a partition with depth: ${getSplitDepth} #####");
      visitor.execute(this);
  }

  void acceptRoomCreatorVisitor(RoomCreatorVisitor visitor){
    log.info("##### create room in rect. depth: ${getSplitDepth} #####");
    visitor.execute(this);
  }

  void acceptConsolidatorVisitor(PartitionArrangerVisitor visitor){
    log.info("##### consolid a rect. depth: ${getSplitDepth} #####");
    // 各Treeの結合配列はそれぞれのcacheに格納されるので戻す必要はない。
    var _ = visitor.execute(this);
  }

  Partition({required this.depth, required this.isRoot, required this.rect, required this.absArea, required this.name}) {
  }

}