import 'package:push_puzzle/bsp/area.dart';
import 'package:push_puzzle/bsp/mst/mst.dart';
import 'package:push_puzzle/bsp/strategy/strategy.dart';
import 'package:push_puzzle/bsp/visitor/visitor.dart';

import '../structure/partition.dart';

class CorridorCreateStrategy extends Strategy {
  final MST mst = MST();


  @override
  void execute() {
      ({List<Partition> partition, List<Edge> edge}) target = createEdges(leafs);
      List <Edge> mstResult = calculate(target.edge, target.partition.length);
    }


  ({List<Partition> partition, List<Edge> edge}) createEdges(List<Partition> leafs) {
    List<Partition> targetLeafs = [];
    for (Partition p in leafs) {
      if (p.hasRoomArea) {
        targetLeafs.add(p);
      }
    }

    List<Edge> edges = [];
    for (int i = 0; i < targetLeafs.length; i++) {
      for (int j = i + 1; j < targetLeafs.length; j++) {
        Point source = targetLeafs[i].absRoomArea.center();
        Point destination = targetLeafs[j].absRoomArea.center();
        edges.add(
            Edge(
                source: i,
                destination: j,
                weight: source.distanceOf(destination).toInt()
            ));
      }
    }
    ({List<Partition> partition ,List<Edge> edge}) target = (partition: targetLeafs, edge: edges);
    return target;
  }

  List<Edge> calculate(List<Edge> target, int numbOfVertices) {
    return mst.kruskalMST(target, numbOfVertices);
  }
  CorridorCreateStrategy({required leafs, required field}) : super(leafs: leafs, field: field);
}