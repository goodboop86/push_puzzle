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
    trace2d(cache.getRect);
  }
  }