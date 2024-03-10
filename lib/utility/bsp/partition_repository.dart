// 再帰構造を持つツリークラス
import 'dart:math';

import 'package:push_puzzle/utility/bsp/util.dart';

class PartitionRepository {
  final Util u = Util();
  final double _splitAxisBias = 0.1;
  final double _splitRatioBias = 0.25;
  late String _splitAxis;
  late double _splitRatio;
  late int _depth;
  late int _childNumber;
  late List<List<int>> _rect;

  set setDepth(int depth) {_depth = depth;}
  set setChildNumber(int childNumber) {_childNumber = childNumber;}
  set setRect(List<List<int>> rect) => {_rect = rect};

  get getSplitAxis => _splitAxis;
  get getSplitRatio => _splitRatio;
  get getRect => _rect;

  void trace3d(_) => u.trace3d(_);

  void traceChildWithInfo(List<List<int>> child) {
    String type = "";
    if (_splitAxis=="vertical") {
      if(_childNumber == 0) {type="L";}
      if(_childNumber == 1) {type="R";}
    } else if(_splitAxis=="horizontal") {
      if(_childNumber == 0) {type="U";}
      if(_childNumber == 1) {type="D";}
    }
    print("SplitAxis: $_splitAxis, SplitRatio: $_splitRatio, Depth: $_depth, childPosition: $type");
    u.trace2d(child);
    print("---");
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