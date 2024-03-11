import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/visitor.dart';

class PartitionVisitor extends Visitor {
  //int depth = 0;
  int access = 0;
  //List<int> idList = [];

  @override
  void visit(Partition partition) {
    access += 1;
    partition.accept(this);
  }

  List<List<int>> getMergedRect(Partition p){
    return p.getMergedRect();
  }

  bool isCreateChildren(Partition p) {
    bool isShouldCreate = p.depth < p.repo.getSplitDepth ? true : false;

    // - 分割可能かはsplit()で利用するsublistへ渡すindexによって代わる
    // - sublistはsublist(0,0)などでも空配列を返せるのでexceptionはしない
    // - なので判定はisEmptyで良いが要素数1の場合にloopが続くので1以上が良さそう
    // memo: min(splitRatio)=biasなので、index境界は bias * 縦or横幅の四捨五入
    // biasが0.3、幅3ならindex境界は0.9->1となりsublist(0,1), sublist(1,3)が成立する
    bool isCreatable = p.repo.getRect.length > 1;

    return isShouldCreate && isCreatable;
  }

  void createChildren(Partition p) {
    p.children = [];
    // 分割回数が十分でないならchildrenの作成を繰り返す
    if (isCreateChildren(p)) {
      List<List<List<int>>> pair = split(p);
      p.depth = p.depth;

      pair.asMap().forEach((int i, var leaf) {
        p.repo.leafNumber = i;
        p.repo.traceLeafWithInfo(leaf);
        p.children.add(Partition.initialize(this, rect: leaf, depth: p.depth, isRoot: false, name: p.repo.getName + p.repo.getLeafPosition()));
      });
      Partition.initialize_(1);
    } else {
      p.depth = p.depth;
    }
    for (var child in p.children) {visit(child);}
    // p.children.forEach((child) {visit(child);});
  }

  // 2次元配列をパラメータに従って分割する。
  List<List<List<int>>> split(Partition p) {

    List<List<int>> rect = p.repo.getRect;
    int height = rect.length;
    int width = rect.first.length;
    p.repo.adjustSplitAxis();
    String axis = p.repo.getSplitAxis;
    p.repo.adjustSplitRatio();
    double ratio = p.repo.getSplitRatio;

    List<List<List<int>>>? pair = [];
    if (axis == "horizontal") {
      int idx = (height * ratio).toInt();
      // memo: sublistの第２引数の配列番号は含まれない
      pair = [
        rect.sublist(0, idx),
        rect.sublist(idx, height)
      ];
    } else if (axis == "vertical") {
      int idx = (width * ratio).toInt();
      pair = [
        rect.map((row) => row.sublist(0, idx)).toList(),
        rect.map((row) => row.sublist(idx, width)).toList()
      ];
    }

    // splitが作成されていなければexception(無い想定)
    if (pair.isEmpty) {
      throw Exception();
    } else {
      return pair;
    }
  }





  PartitionVisitor();
}

void main() {

  DungeonConfig dungeonConfig = DungeonConfig();
  var initialRect =List.generate(dungeonConfig.dungeonHeight,
          (i) => List.generate(dungeonConfig.dungeonWidth, (j) => 8));
  PartitionVisitor visitor = PartitionVisitor();
  Partition partition = Partition.initialize(visitor, depth: dungeonConfig.initialDepth,
      isRoot: dungeonConfig.initialIsRoot,
      rect: initialRect,
      name: dungeonConfig.rootName);
  visitor.visit(partition);
  var res = visitor.getMergedRect(partition);
  print(res);
}