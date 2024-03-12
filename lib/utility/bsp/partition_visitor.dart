import 'package:push_puzzle/utility/bsp/partition.dart';
import 'package:push_puzzle/utility/bsp/visitor.dart';

class PartitionVisitor extends Visitor {
  int depth = 0;
  int access = 0;
  List<int> idList = [];

  @override
  void visit(Partition partition) {
    access += 1;
    partition.acceptPartitionVisitor(this);
  }
  List<Partition> createChildren(int depth){
    return [Partition.initialize(depth: depth+1), Partition.initialize(depth: depth+1)];
  }
  void storeData(Partition partition) {
    depth = partition.depth;
    idList.add(partition.id);
  }
  PartitionVisitor();
}

void main() {
  Partition partition = Partition.initialize(depth: 0);
  PartitionVisitor visitor = PartitionVisitor();
  visitor.visit(partition);
  print(visitor.access);
}