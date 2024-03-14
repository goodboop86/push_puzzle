extension List2DExtension on List<List<int>> {
  int get height => length;
  int get width => first.length;

}

void main() {
  var list = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];


}