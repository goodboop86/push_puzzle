// 再帰構造を持つツリークラス
import 'dart:math';

import 'package:push_puzzle/utility/bsp/util.dart';

class PartitionRepository {
  final Util u = Util();
  final double _splitAxisBias = 0.1;
  final double _splitRatioBias = 0.25;
  final bool _isDebug = true;
  late String _splitAxis;
  late double _splitRatio;
  late int _depth;
  late int _leafNumber;
  late List<List<int>> _rect;
  String _name = "";
  late bool _isRoot;

  set depth(int depth) {_depth = depth;}
  set leafNumber(int childNumber) {_leafNumber = childNumber;}
  set rect(List<List<int>> rect) => {_rect = rect};
  set name(String name) => {_name = name};
  set isRoot(bool isRoot) => {_isRoot = isRoot};

  get getSplitAxis => _splitAxis;
  get getSplitRatio => _splitRatio;
  get getRect => _rect;
  get getName => _name;
  get getIsRoot => _isRoot;

  void trace3d(_) => u.trace3d(_);

  void traceLeafWithInfo(List<List<int>> leaf) {
    String name = _name +  getLeafPosition();
    if (_isDebug) {
      print("##########");
      print("SplitAxis: $_splitAxis, SplitRatio: $_splitRatio, Name: $name");
      u.trace2d(leaf);
      print("---");
    }
  }

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