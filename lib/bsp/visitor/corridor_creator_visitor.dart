import 'package:push_puzzle/bsp/area.dart';
import 'package:push_puzzle/bsp/mst/mst.dart';
import 'package:push_puzzle/bsp/visitor/visitor.dart';

import '../structure/partition.dart';

class CorridorCreatorVisitor extends Visitor {
  final MST mst = MST();
  List<Partition> leafChildren;

  @override
  void visit(Partition partition, {bool isDebug = false}) {
    this.isDebug = isDebug;
    partition.acceptCorridorCreatorVisitor(this);
  }

  @override
  void execute(Partition p) {
    if (shouldExecute(p)) {
      ({List<Partition> partition, List<Edge> edge}) target = createEdges(leafChildren);
      List <Edge> mstResult = calculate(target.edge, target.partition.length);


    }

  }

  @override
  bool shouldExecute(Partition p) {
    return true;
  }
  @override
  void trace(Partition p) {
  }
  CorridorCreatorVisitor({required config, required this.leafChildren}) : super(config);

  ({List<Partition> partition, List<Edge> edge}) createEdges(List<Partition> leafChildren) {

    List<Partition> targetChildren = [];
    for (Partition p in leafChildren) {
      if (p.hasRoomArea) {
        targetChildren.add(p);
      }
    }

    List<Edge> edges = [];
    for (int i = 0; i < targetChildren.length; i++) {
      for (int j = i + 1; j < targetChildren.length; j++) {
        Point source = targetChildren[i].absRoomArea.center();
        Point destination = targetChildren[j].absRoomArea.center();
        edges.add(
            Edge(
                source: i,
                destination: j,
                weight: source.distanceOf(destination).toInt()
            ));
      }
    }
    ({List<Partition> partition ,List<Edge> edge}) target = (partition: targetChildren, edge: edges);
    return target;
  }

  List<Edge> calculate(List<Edge> target, int numbOfVertices) {
    return mst.kruskalMST(target, numbOfVertices);
  }
}