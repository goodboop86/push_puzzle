// FIXME: Visitorの実装サンプル。消しても他のクラスに影響しないので消して良い。

import 'dart:math';

class Tree {
  late int depth;
  late int id;
  late Tree child;

  void accept(Visitor visitor) {
    visitor.storeTreeData(this);
    if(depth < 5){
      // 一定の深さまで作成しつづける。
      child = visitor.createChild(depth);
      visitor.visit(child);
    }
  }
  Tree({required int d}) {
    depth = d + 1;
    id = Random().nextInt(100);
  }
}

class Visitor {
  int access = 0;
  List<int> idList = [];

  void visit(Tree company) {
    company.accept(this);
  }
  Tree createChild(int depth) {
    return Tree(d: depth);
  }
  void storeTreeData(Tree tree) {
    access = tree.depth;
    idList.add(tree.id);
  }
  Visitor();
}

void main() {
  Tree company = Tree(d: 0);
  Visitor visitor = Visitor();
  visitor.visit(company);

  print(visitor.access);

}