import 'package:logging/logging.dart';

extension List2DExtension on List<List<int>> {
  debugField() {
    List<String> block = ["#", "%", " "];
    Logger l = Logger('List2DExtension');
    forEach((row) {
      List<String> tmp = [];
      for (int i in row) {
        tmp.add(block[i]);
      }
      l.info(tmp);
    });
    l.info("---");
  }

  debugPrint() {
    Logger l = Logger('List2DExtension');
    forEach((row) {
      l.info(row);
    });
    l.info("---");
  }
}

void main() {
  Logger.root.level = Level.ALL; // すべてのログを取得します。
  Logger.root.onRecord.listen((record) {});

  var list = [
    [0, 0, 1],
    [0, 1, 1],
    [0, 1, 2],
  ];

  list.debugField();
}
