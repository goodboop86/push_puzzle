import 'package:logging/logging.dart';
import 'package:push_puzzle/algorithm/structure/partition.dart';

import '../visitor_config.dart';

abstract class Visitor {
  late VisitorConfig config = VisitorConfig();
  final Logger logging = Logger('Visitor');
  late bool isDebug;
  void visit(Partition partition);
  void trace(Partition p);
  execute(Partition p);
  shouldExecute(Partition p);
  Visitor(this.config);
}
