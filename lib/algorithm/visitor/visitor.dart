
import 'package:logging/logging.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';

import '../dungeon_config.dart';

abstract class Visitor {
 final DungeonConfig config = DungeonConfig();
 final Logger logging = Logger('Visitor');
 late bool isDebug;
 void visit(Partition partition);
 void _trace();
 execute(Partition p);
 shouldExecute(Partition p);
}