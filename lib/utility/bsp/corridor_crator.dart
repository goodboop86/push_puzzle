import 'package:push_puzzle/utility/bsp/creator.dart';

class CorridorCreator implements Creator {
  bool isCreatable() {
    return true;
  }
  List<List<int>> create(){
    return [];
  }
}