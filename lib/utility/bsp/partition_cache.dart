// 再帰構造を持つツリークラス
import 'dart:math';

import 'package:push_puzzle/utility/bsp/area.dart';
import 'package:push_puzzle/utility/bsp/Tracer.dart';


class PartitionCache {

  // Partition生成に関わる設定
  final double _splitAxisBias = 0.1;
  final double _splitRatioBias = 0.25;
  final int _splitDepth = 3;
  final bool _isDebug = false;
  late String _splitAxis = "";
  late double _splitRatio = -1;
  int depth = -1;
  late int _leafNumber;
  late List<List<int>> _rect;
  String _name = "";
  late bool _isRoot;
  late Area _roomArea;
  late Area _gridArea;
  late List<List<int>> _consolidRect;

  //set depth(int depth) {_depth = depth;}
  set leafNumber(int childNumber) {_leafNumber = childNumber;}
  set rect(List<List<int>> rect) => {_rect = rect};
  set name(String name) => {_name = name};
  set isRoot(bool isRoot) => {_isRoot = isRoot};
  set roomArea(Area roomArea) => {_roomArea = roomArea};
  set gridArea(Area gridArea) => {_gridArea = gridArea};
  set consolidRect(var consolidRect) => {_consolidRect = consolidRect};

  get getSplitAxisBias => _splitAxisBias;
  get getSplitRatioBias => _splitRatioBias;
  get getSplitDepth => _splitDepth;
  get getIsDebug => _isDebug;
  get getSplitAxis => _splitAxis;
  get getSplitRatio => _splitRatio;

  // roomCreatorに関する設定
 // get getDepth => _depth;
  get getRect => _rect;
  get getName => _name;
  get getIsRoot => _isRoot;
  get getRoomArea => _roomArea;
  get getGridArea => _gridArea;
  get getConsolidRect => _consolidRect;


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
    _splitAxis =  (_rect.length/_rect.first.length) + (Random().nextDouble() * _splitAxisBias) > 1 ? "horizontal" : "vertical";
  }

  // 長方形を分割する比率を決める。
  void adjustSplitRatio() {
    _splitRatio =  Random().nextDouble() / 2 + _splitRatioBias;
  }


}