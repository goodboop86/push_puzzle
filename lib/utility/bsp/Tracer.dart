import 'package:push_puzzle/utility/bsp/partition_cache.dart';

class CacheTracer {

  void trace2d(List<List<int>> lis2d) {
    lis2d.forEach((row) {
      print(row);
    });
    print('---');
  }
  void trace3d(List<List<List<int>>> lis3d) {
    print(StackTrace.current.toString());
    lis3d.forEach((lis2d) {
      lis2d.forEach((raw) {
        print(raw);
      });
      print('---');
    });
  }
  void traceInfo(PartitionCache cache){
    print("#########################\n"
        "PRTITION INFO\n"
        "Root: ${cache.getIsRoot}, depth: ${cache.getDepth}/${cache.getSplitDepth}, Debug: ${cache.getIsDebug}\n"
        "name: ${cache.getName}, Split axis: ${cache.getSplitAxis} (bias: ±${cache.getSplitAxisBias}), Sprit ratio: ${cache.getSplitRatio} (bias: ±${cache.getSplitRatioBias})\n"
    );
    trace2d(cache.getRect);
  }
  }