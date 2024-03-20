import 'dart:math';

import 'package:push_puzzle/bsp/area.dart';
import 'package:push_puzzle/bsp/extention/list2d_extention.dart';
import 'package:push_puzzle/bsp/strategy/direction.dart';
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
    for(var edge in edges){
      Partition source = leafs[edge.source];
      Partition destination = leafs[edge.destination];
      createCorridor(source, destination);
    }
    return material;
  }

  void createCorridor(Partition source, Partition destination) {
    Duplicate duplicate = source.absRoomArea.overWrapDirectionTo(destination.absRoomArea);

    if (duplicate == Duplicate.none) {
      createBendCorridor(source, destination);
    } else {
      createPlainCorridor(source, destination, duplicate);
    }
  }

void createPlainCorridor(Partition source, Partition destination, Duplicate duplicate) {
    Point distance = source.absRoomArea.center().distanceOf(destination.absRoomArea.center());

    // Direction sourceDirection;
    // Direction destinationDirection;
    Area sourceCorridor;
    Area destinationCorridor;
    Area betweenCorridor;
    List<Area> corridors = [];
    int bias = 1;
    Point sStart;
    Point sEnd;
    Point dStart;
    Point dEnd;

    logging.info(duplicate);
    logging.info(distance.toString());
    // source/destinationの通路作成に関する方針を決める
    int boundary;
    if(duplicate == Duplicate.X) {
      if(distance.x > 0) {
        //sourceDirection = Direction.right;
        //destinationDirection = Direction.left;

        int corridorDistance = (source.absRoomArea.to.x - destination.absRoomArea.from.x);
        boundary = destination.absRoomArea.from.x + corridorDistance ~/ 2;

        sStart = Point(y:source.absRoomArea.to.y - bias, x: source.absRoomArea.to.x);
        sEnd = Point(y:source.absRoomArea.to.y - bias, x: boundary);
        dStart = Point(y:destination.absRoomArea.from.y + bias, x: boundary);
        dEnd = Point(y:destination.absRoomArea.from.y + bias, x: destination.absRoomArea.from.x);
      } else {
        //sourceDirection = Direction.left;
        //destinationDirection = Direction.right;

        int corridorDistance = (source.absRoomArea.from.x - destination.absRoomArea.to.x);
        boundary = destination.absRoomArea.to.x + corridorDistance ~/ 2;

        dStart = Point(y:destination.absRoomArea.to.y - bias, x: destination.absRoomArea.to.x);
        dEnd = Point(y:destination.absRoomArea.to.y - bias, x: boundary);
        sStart = Point(y:source.absRoomArea.from.y + bias, x: boundary);
        sEnd = Point(y:source.absRoomArea.from.y + bias, x: source.absRoomArea.from.x);
      }


    } else if (duplicate == Duplicate.Y) {
      if(distance.y > 0) {
        //sourceDirection = Direction.down;
        //destinationDirection = Direction.up;

        int corridorDistance = (source.absRoomArea.to.y - destination.absRoomArea.from.y);
        boundary = destination.absRoomArea.from.y + corridorDistance ~/ 2;

        sStart = Point(y:source.absRoomArea.to.y, x: source.absRoomArea.to.x - bias);
        sEnd = Point(y:boundary, x: source.absRoomArea.to.x - bias);
        dStart = Point(y:boundary, x: destination.absRoomArea.from.x + bias);
        dEnd = Point(y:destination.absRoomArea.from.y, x: destination.absRoomArea.from.x + bias);

      } else {
        //sourceDirection = Direction.up;
        //destinationDirection = Direction.down;

        int corridorDistance = (source.absRoomArea.from.y - destination.absRoomArea.to.y);
        boundary = destination.absRoomArea.to.y + corridorDistance ~/ 2;

        dStart = Point(y:destination.absRoomArea.to.y, x: destination.absRoomArea.to.x - bias);
        dEnd = Point(y:boundary, x: destination.absRoomArea.to.x - bias);
        sStart = Point(y:boundary, x: source.absRoomArea.from.x + bias);
        sEnd = Point(y:source.absRoomArea.from.y, x: source.absRoomArea.from.x + bias);

      }
    } else {
      throw Exception("Invalid duplicate");
    }
    corridors.addAll([Area(from: sStart, to: sEnd), Area(from: dStart, to: dEnd), Area(from: sEnd, to: dStart)]);

    for(Area corridor in corridors) {
      logging.info(corridor.toString());
    }

    for(Area corridor in corridors) {
      draw(corridor);
      field.debugPrint();
    }
  }

  void draw(Area area) {
    for(int i = 0; i <= field.length; i++) {
      for(int j = 0; j <= field.first.length; j++) {
        if(area.isIn(i, j)) {
          field[i][j] = 1;
          print("draw: $i, $j");
        }
      }
    }
  }


  get getBoundaryRatio => Random().nextDouble() / 2 + config.boundaryRatioBias;

  void createBendCorridor(Partition source, Partition destination) {
    Point sourcePoint = source.absRoomArea.getRandomPoint();
    Point destinationPoint = destination.absRoomArea.getRandomPoint();

    List<Point> cornerPoint = [
      Point(y: sourcePoint.y, x: destinationPoint.x),
      Point(y: destinationPoint.y, x: sourcePoint.x)];

    Point bendPoint = cornerPoint[Random().nextInt(2)];

    if(sourcePoint.isCompletelyLargerThan(sourcePoint)){
      draw(Area(from: sourcePoint, to: bendPoint));
      field.debugPrint();
      draw(Area(from: bendPoint, to: destinationPoint));
      field.debugPrint();
    } else {
      draw(Area(from: destinationPoint, to: bendPoint));
      field.debugPrint();
      draw(Area(from: bendPoint, to: sourcePoint));
      field.debugPrint();
    }
  }


  @override
  void trace() {}
  CorridorCreateStrategy({required super.material}) {
    leafs = material.leafs;
    edges = material.edges;
    field = material.field;
  }
}