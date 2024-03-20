import 'dart:math';

class Point {
  late int y;
  late int x;
  Point({required this.y, required this.x});

  double squaredDistanceOf(Point p) {
    return sqrt(pow(p.y - y, 2) + pow(p.x - x, 2));
  }

  Point distanceOf(Point destination) {
    return Point(y: destination.y - y,  x: destination.x - x);
  }

  bool isCompletelyLargerThan(Point p) {
    return y > p.y && x > p.x;
  }

  @override
  String toString() {
    return "y: $y, x: $x";
  }
}

class Area {
  late Point from;
  late Point to;
  Area({required this.from, required this.to});

  bool isIn(int y, int x) =>
      y >= from.y && y <= to.y && x >= from.x && x <= to.x;

  Point center() {
    return Point(y: (from.y + to.y) ~/ 2, x: (from.x + to.x) ~/ 2);
  }

  List<int> shape() {
    return [to.y - from.y, to.x - from.x];
  }

  Duplicate overWrapDirectionTo(Area another) {
    List<int> xRange = List.generate(
        to.x - from.x, (index) => index + from.x);
    List<int> anotherXRange = List.generate(
        another.to.x - another.from.x, (index) => index + another.from.x);

    print(xRange);
    print(anotherXRange);

    List<int> duplication = xRange.where((element) => anotherXRange.contains(element)).toList();

    if(duplication.isNotEmpty) {return Duplicate.X;}

    List<int> yRange = List.generate(
        to.y - from.y, (index) => index + from.y);
    List<int> anotherYRange = List.generate(
        another.to.y - another.from.y, (index) => index + another.from.y);

    print(yRange);
    print(anotherYRange);

    duplication = yRange.where((element) => anotherYRange.contains(element)).toList();

    if(duplication.isNotEmpty) {return Duplicate.Y;}

   return Duplicate.none;

  }

  Point getRandomPoint() {

    print(toString());
    return Point(
        y: Random().nextInt(to.y - from.y) + from.y,
        x: Random().nextInt(to.x - from.x) + from.x);
  }

  Area add(Point p) {
    return Area(
        from: Point(y: from.y + p.y, x: from.x + p.x),
        to: Point(y: to.y + p.y, x: to.x + p.x));
  }

  @override
  String toString() {
    return "from (y: ${from.y}, x: ${from.x}) to (y: ${to.y}, x: ${to.x})";
  }
}

enum Duplicate { X, Y, none}