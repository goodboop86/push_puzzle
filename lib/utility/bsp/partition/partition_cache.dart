// 再帰構造を持つツリークラス
import 'dart:math';

import 'package:push_puzzle/utility/bsp/area.dart';
import 'package:push_puzzle/utility/bsp/extention/list2d_extention.dart';


class PartitionCache {

  // 初期設定値
  final double _splitRatioBias = 0.25;
  final int _splitDepth = 2;
  final bool _isDebug = false;
  late bool _isRoot;

  // 共通設定
  late List<List<int>> _rect;
  late Area _absArea;
  String _name = "";
  int depth = -1;

  // createChildrenに関する設定
  late String _splitAxis = "";
  late double _splitRatio = -1;
  late int _leafNumber;
  final double _splitAxisBias = 0.1;


  // roomCreatorに関する設定
  late Area _gridArea;
  late Area _roomArea;

  // 結合に関する設定
  late List<List<int>> _consolidRect;


  set leafNumber(int _) {_leafNumber = _;}
  set rect(List<List<int>> _) => {_rect = _};
  set name(String _) => {_name = _};
  set isRoot(bool _) => {_isRoot = _};
  set roomArea(Area _) => {_roomArea = _};
  set gridArea(Area _) => {_gridArea = _};
  set consolidRect(var _) => {_consolidRect = _};
  set absArea(Area _) => {_absArea = _};

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
  get getAbsArea => _absArea;


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