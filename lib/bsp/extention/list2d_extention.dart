import 'package:logging/logging.dart';

extension List2DExtension on List<List<int>> {
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
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];

  list.debugPrint();
}
