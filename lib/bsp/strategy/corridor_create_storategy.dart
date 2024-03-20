import 'dart:math';

import 'package:push_puzzle/bsp/area.dart';
import 'package:push_puzzle/bsp/extention/list2d_extention.dart';
import 'package:push_puzzle/bsp/strategy/strategy.dart';
import 'package:push_puzzle/bsp/strategy/strategy_config.dart';
import 'package:push_puzzle/bsp/strategy/strategy_material.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';
import 'mst_strategy.dart';

class CorridorCreateStrategy extends Strategy {
  final StrategyConfig config = StrategyConfig();
  late List<Partition> leafs;
  late List<Edge> edges;
  late List<List<int>> field;

  @override
  StrategyMaterial execute() {
    for (var edge in edges) {
      Partition source = leafs[edge.source];
      Partition destination = leafs[edge.destination];
      createCorridor(source, destination);
    }
    return material;
  }

  void createCorridor(Partition source, Partition destination) {
    Duplicate duplicate =
        source.absRoomArea.overWrapDirectionTo(destination.absRoomArea);

    logging.info(duplicate);

    if (duplicate == Duplicate.none) {
      createBendCorridor(source, destination);
    } else {
      createPlainCorridor(source, destination, duplicate);
    }
  }

  void createPlainCorridor(
      Partition source, Partition destination, Duplicate duplicate) {
    // distance of destination - source
    Point centerDistance = source.absRoomArea
        .center()
        .distanceOf(destination.absRoomArea.center());

    // Direction sourceDirection;
    // Direction destinationDirection;
    List<Area> corridors = [];
    int bias = 1;

    // source/destinationの通路作成に関する方針を決める
    int boundaryIdx;
    Partition former = source;
    Partition latter = destination;
    Point fStart;
    Point fEnd;
    Point lStart;
    Point lEnd;
    Point bStart; // between start
    Point bEnd; // between start
    if (duplicate == Duplicate.X) {
      if (centerDistance.y < 0) {
        former = destination;
        latter = source;
      }
      int corridorDistance =
          (latter.absRoomArea.from.y - former.absRoomArea.to.y);
      boundaryIdx = former.absRoomArea.to.y + (corridorDistance ~/ 2);

      int fBias = (former.roomShape.width * getCorridorGateRatio).toInt();
      int lBias = (latter.roomShape.width * getCorridorGateRatio).toInt();
      fStart =
          Point(y: former.absRoomArea.to.y, x: former.absRoomArea.to.x - fBias);
      fEnd = Point(y: boundaryIdx, x: former.absRoomArea.to.x - fBias);
      lStart = Point(y: boundaryIdx, x: latter.absRoomArea.from.x + lBias);
      lEnd = Point(
          y: latter.absRoomArea.from.y, x: latter.absRoomArea.from.x + lBias);

      bStart = fEnd.x < lStart.x ? fEnd : lStart;
      bEnd = fEnd.x > lStart.x ? fEnd : lStart;
    } else if (duplicate == Duplicate.Y) {
      if (centerDistance.x < 0) {
        former = destination;
        latter = source;
      }
      int corridorDistance =
          (latter.absRoomArea.from.x - former.absRoomArea.to.x);
      boundaryIdx = former.absRoomArea.to.x + (corridorDistance ~/ 2);

      int fBias = (former.roomShape.height * getCorridorGateRatio).toInt();
      int lBias = (latter.roomShape.height * getCorridorGateRatio).toInt();
      fStart =
          Point(y: former.absRoomArea.to.y - fBias, x: former.absRoomArea.to.x);
      fEnd = Point(y: former.absRoomArea.to.y - fBias, x: boundaryIdx);
      lStart = Point(y: latter.absRoomArea.from.y + lBias, x: boundaryIdx);
      lEnd = Point(
          y: latter.absRoomArea.from.y + lBias, x: latter.absRoomArea.from.x);

      bStart = fEnd.y < lStart.y ? fEnd : lStart;
      bEnd = fEnd.y > lStart.y ? fEnd : lStart;
    } else {
      throw Exception("Invalid duplicate");
    }
    corridors.addAll([
      Area(from: fStart, to: fEnd),
      Area(from: lStart, to: lEnd),
      Area(from: bStart, to: bEnd)
    ]);

    for (Area corridor in corridors) {
      logging.info("## draw createPlainCorridor -> ${corridor.toString()}");
      draw(corridor);
    }
    field.debugField();
  }

  void draw(Area area) {
    for (int i = 0; i <= field.length; i++) {
      for (int j = 0; j <= field.first.length; j++) {
        if (area.isIn(i, j)) {
          field[i][j] = 2;
        }
      }
    }
  }

  get getBoundaryRatio => Random().nextDouble() / 2 + config.boundaryRatioBias;
  get getCorridorGateRatio =>
      Random().nextDouble() / 2 + config.boundaryRatioBias;

  void createBendCorridor(Partition source, Partition destination) {
    Point sourcePoint = source.absRoomArea.getRandomPoint();
    Point destinationPoint = destination.absRoomArea.getRandomPoint();

    List<Point> cornerPoint = [
      Point(y: sourcePoint.y, x: destinationPoint.x),
      Point(y: destinationPoint.y, x: sourcePoint.x)
    ];

    Point bendPoint = cornerPoint[Random().nextInt(2)];

    logging.info(
        "## draw createBendCorridor -> ${sourcePoint.toString()} -> ${bendPoint.toString()} -> ${destinationPoint.toString()}");

    Area former = Area(from: sourcePoint, to: bendPoint);
    Area latter = Area(from: bendPoint.deepCopy(), to: destinationPoint);

    former.modify();
    latter.modify();
    draw(former);
    draw(latter);
  }

  @override
  void trace() {}
  CorridorCreateStrategy({required super.material}) {
    leafs = material.leafs;
    edges = material.edges;
    field = material.field;
  }
}
