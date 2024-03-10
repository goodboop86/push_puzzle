import 'package:push_puzzle/utility/bsp/dungeon_config.dart';
import 'package:push_puzzle/utility/bsp/room_creator.dart';
import 'package:push_puzzle/utility/bsp/util.dart';

import 'partition_repository.dart';

class Partition {
  late List<Partition> children;
  late int depth;
  late PartitionRepository repo = PartitionRepository();
  late DungeonConfig config = DungeonConfig();
  late RoomCreator roomCreator = RoomCreator(config: config);


  // 2次元配列をパラメータに従って分割する。
  List<List<List<int>>> split() {

    List<List<int>> rect = repo.getRect;
    int height = rect.length;
    int width = rect.first.length;
    repo.adjustSplitAxis();
    String axis = repo.getSplitAxis;
    repo.adjustSplitRatio();
    double ratio = repo.getSplitRatio;

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

  bool isCreateChildren() {
    bool isShouldCreate = depth < repo.getSplitDepth ? true : false;

    // - 分割可能かはsplit()で利用するsublistへ渡すindexによって代わる
    // - sublistはsublist(0,0)などでも空配列を返せるのでexceptionはしない
    // - なので判定はisEmptyで良いが要素数1の場合にloopが続くので1以上が良さそう
    // memo: min(splitRatio)=biasなので、index境界は bias * 縦or横幅の四捨五入
    // biasが0.3、幅3ならindex境界は0.9->1となりsublist(0,1), sublist(1,3)が成立する
    bool isCreatable = repo.getRect.length > 1;

    return isShouldCreate && isCreatable;
  }

  void createChildren() {
    children = [];
    // 分割回数が十分でないならchildrenの作成を繰り返す
    if (isCreateChildren()) {
      List<List<List<int>>> pair = split();
      repo.depth = depth;

      // FIXME: logの出すタイミングとPartitionのタイミングが別で二重処理っぽい。
      // FIXME: この辺のクラス構造を整理したい。
      pair.asMap().forEach((int i, var leaf) {
        repo.leafNumber = i;
        repo.traceLeafWithInfo(leaf);
        children.add(Partition(rect: leaf, depth: depth, isRoot: false, name: repo.getName + repo.getLeafPosition()));
      });
    } else {
      repo.depth = depth;
    }
  }

  List<List<int>> getMergedRect(){
    bool isEdge = children.isEmpty;
    Util u = Util();
    if(isEdge) {
      return repo.getRect;
    } else {
      //要素2
      List<List<List<int>>> pair =[];
      children.forEach((child) {pair.add(child.getMergedRect());});

      if (repo.getSplitAxis == "horizontal") {
        return pair[0] + pair[1];
      } else if (repo.getSplitAxis == "vertical") {
        List<List<int>> merged = [];
        for (int i = 0; i < pair[0].length; i++) {
          merged.addAll([pair[0][i] + pair[1][i]]);
        }
        return merged;
      } else {
        // 無い想定
        Exception();
        return [];
      }
    }
  }

  void traceInfo(){
    print("#########################\n"
        "PRTITION INFO\n"
        "Root: ${repo.getIsRoot}, depth: ${repo.getDepth}/${repo.getSplitDepth}, Debug: ${repo.getIsDebug}\n"
        "name: ${repo.getName}, Split axis: ${repo.getSplitAxis} (bias: ±${repo.getSplitAxisBias}), Sprit ratio: ${repo.getSplitRatio} (bias: ±${repo.getSplitRatioBias})\n"
    );
    Util().trace2d(repo.getRect);
    if(children.isNotEmpty) {
      children.forEach((child) {child.traceInfo();});
    }
  }

  void createRoomIfIsEdge() {
    // 末端のnodeを指定して生成する必要がある。
    if(children.isEmpty) {
      var rect = repo.getRect;
      repo.rect = roomCreator.createAndUpdateAreas(rect);
    } else {
      // 末端でなければ子階層を呼び出す。
      children.forEach((child) {
        child.createRoomIfIsEdge();});
    }
  }

  Partition({required this.depth, required isRoot, required List<List<int>> rect, required String name}) {
    repo.rect = rect;
    repo.isRoot = isRoot;
    repo.name = name;
    depth += 1;
    createChildren();
  }
}