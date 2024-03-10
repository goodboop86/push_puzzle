// 再帰構造を持つツリークラス
import 'dart:math';

import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/util.dart';

class PartitionRepository {
  final Util u = Util();
  final double splitAxisBias = 0.1;
  final double splitRatioBias = 0.25;
  late String _splitAxis;
  late double _splitRatio;
  late int _depth;
  late int _leafNumber;
  late List<List<int>> _rect;


  // set setSplitAxis(String splitAxis) {_splitAxis = splitAxis;}
  set setDepth(int depth) {_depth = depth;}
  set setLeafNumber(int leafNumber) {_leafNumber = leafNumber;}
  set setRect(List<List<int>> rect) => {_rect = rect};

  get getSplitAxis => _splitAxis;
  get getSplitRatio => _splitRatio;
  get getDepth => _depth;
  get getLeafNumber => _leafNumber;
  get getRect => _rect;

  void trace3d(_) => u.trace3d(_);

  void traceLeafWithInfo(List<List<int>> child) {
    String type = "";
    if (_splitAxis=="vertical") {
      if(getLeafNumber == 0) {type="L";}
      if(getLeafNumber == 1) {type="R";}
    } else if(_splitAxis=="horizontal") {
      if(getLeafNumber == 0) {type="U";}
      if(getLeafNumber == 1) {type="D";}
    }
    print("SplitAxis: $getSplitAxis, SplitRatio: $getSplitRatio, Depth: $getDepth, LeafPosition: $type");
    u.trace2d(child);
    print("---");
  }

  // 長方形を分割する方向を決める。
  // ectのy/x比率 (± bias) > 1以上なら縦長なのでhorizontalに分割する。
  void adjustSplitAxis() {
    _splitAxis =  (getRect.length/getRect.first.length) + (Random().nextDouble() * splitAxisBias) > 1 ? "horizontal" : "vertical";
  }

  // 長方形を分割する比率を決める。
  void adjustSplitRatio() {
    _splitRatio =  Random().nextDouble() / 2 + splitRatioBias;
  }


}