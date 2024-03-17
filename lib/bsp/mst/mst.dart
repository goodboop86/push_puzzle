// see: https://medium.com/@sadigrzazada20/a-minimum-spanning-tree-mst-85c6f881d28a
import 'package:logging/logging.dart';


class Edge {
  late int source;
  late int destination;
  late int weight;

  Edge({required this.source, required this.destination,required this.weight});
}

class MST {
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
  MST();
}



void main() {
  Logger logging = Logger('MST');
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  MST mst = MST();

  List<Edge> edges = [
    Edge(source: 0, destination: 1, weight: 2),
    Edge(source: 0, destination: 2, weight: 4),
    Edge(source: 1, destination: 2, weight: 1),
    Edge(source: 1, destination: 3, weight: 7),
    Edge(source: 2, destination: 3, weight: 3),
  ];

  int numberOfVertices = 4;
  List<Edge> minimumSpanningTree = mst.kruskalMST(edges, numberOfVertices);

  logging.info("Edges in the Minimum Spanning Tree:");
  for (var edge in minimumSpanningTree) {
    logging.info("${edge.source} - ${edge.destination} (Weight: ${edge.weight})");
  }
}