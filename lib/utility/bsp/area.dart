

class Coordinate {
  late int y;
  late int x;
  Coordinate({required this.y, required this.x});
}

class Area {
  late Coordinate from;
  late Coordinate to;
  Area({required this.from, required this.to});

  bool isIn(int y, int x) =>
      y >= from.y && y <= to.y &&
          x >= from.x && x <= to.x ;

  Coordinate center(int x, int y) {
    return Coordinate(y: (from.y + to.y)~/2 , x: (from.x + to.x)~/2);
  }
}