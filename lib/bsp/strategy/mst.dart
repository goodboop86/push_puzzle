// see: https://medium.com/@sadigrzazada20/a-minimum-spanning-tree-mst-85c6f881d28a
import 'package:logging/logging.dart';
import 'package:push_puzzle/bsp/area.dart';
import 'package:push_puzzle/bsp/strategy/strategy.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';


class Edge {
  late int source;
  late int destination;
  late int weight;

  @override
  String toString() {
    return "Source: $source, Destination: $destination, Weight: $weight";
  }
  Edge({required this.source, required this.destination,required this.weight});
}

class MSTStrategy extends Strategy {

  @override
  List<Edge> execute() {
    ({List<Partition> partition ,List<Edge> edge}) target = createEdges();
    return kruskalMST(target.edge, target.partition.length);
  }

  int findParent(List<int> parent, int vertex) {
    if (parent[vertex] == -1) {
      return vertex;
    }
    return findParent(parent, parent[vertex]);
  }

  void union(List<int> parent, int x, int y) {
    int xSet = findParent(parent, x);
    int ySet = findParent(parent, y);
    parent[xSet] = ySet;
  }

  ({List<Partition> partition, List<Edge> edge}) createEdges() {
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

  List<Edge> kruskalMST(List<Edge> edges, int numberOfVertices) {
    List<Edge> minimumSpanningTree = [];

    // グラフ内のすべてのエッジを重みに従って昇順に並べ替え
    edges.sort((a, b) => a.weight.compareTo(b.weight));

    //parentを初期化
    List<int> parent = List.generate(numberOfVertices, (j) => -1);

    for (Edge edge in edges) {
      int x = findParent(parent, edge.source);
      int y = findParent(parent, edge.destination);
      if (x != y) {
        minimumSpanningTree.add(edge);
        union(parent, x, y);
      }
    }
    return minimumSpanningTree;
  }
  MSTStrategy({required super.leafs, required super.field});
}