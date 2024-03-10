class Util {
  void trace2d(List<List<int>> lis2d) {
    lis2d.forEach((row) {
      print(row);
    });
    print('---');
  }
  void trace3d(List<List<List<int>>> lis3d) {
    lis3d.forEach((lis2d) {
      lis2d.forEach((raw) {
        print(raw);
      });
      print('---');
    });
  }
  }