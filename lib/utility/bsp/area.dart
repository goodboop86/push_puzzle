

import 'dart:math';

class Point {
  late int y;
  late int x;
  Point({required this.y, required this.x});
}

class Area {
  late Point from;
  late Point to;
  Area({required this.from, required this.to});

  bool isIn(int y, int x) =>
      y >= from.y && y <= to.y &&
          x >= from.x && x <= to.x ;

  Point center(int x, int y) {
    return Point(y: (from.y + to.y)~/2 , x: (from.x + to.x)~/2);
  }

  Point getRandomPint() {
    return Point(
        y: Random().nextInt(from.y - to.y) + from.y,
        x: Random().nextInt(from.x - to.x) + from.x);
  }
}