
import 'package:logging/logging.dart';
import 'package:push_puzzle/utility/bsp/partition/partition.dart';

abstract class Visitor {
 final Logger logging = Logger('Visitor');
 void visit(Partition partition);
 void _trace();
 execute(Partition p);
}