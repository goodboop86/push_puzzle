
import 'package:logging/logging.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';

abstract class Visitor {
 final Logger logging = Logger('Visitor');
 late bool isDebug;
 void visit(Partition partition);
 void _trace();
 execute(Partition p);
}