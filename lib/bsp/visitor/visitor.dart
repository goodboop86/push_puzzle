import 'package:logging/logging.dart';
import 'package:push_puzzle/bsp/structure/partition.dart';

import 'visitor_config.dart';

abstract class Visitor<T extends VisitorConfig> {
  late T config;
  final Logger logging = Logger('Visitor');
  late bool isDebug;
  void visit(Partition partition);
  void trace(Partition p);
  execute(Partition p);
  shouldExecute(Partition p);
  Visitor(this.config);
}
