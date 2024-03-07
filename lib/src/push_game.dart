import 'stage_state.dart';

class PushGame {
  late int _stage;
  late int step;
  late int turn;
  late String action = "none";
  late StageState state;

  PushGame({int stage = 1, this.step = 0, this.turn = 0}) {
    _stage = stage;
    state = StageState(stage: stage);
  }

  int get stage => _stage;
  bool get isFinalStage => state.dataList.length == stage;

  void draw() {
    for (var splitStageState in state.splitStageStateList) {
      print(splitStageState);
    }
  }

  void update(String input) {
    changeMoveState(input);
    draw();
    if (state.isClear) {
      print("Congratulation's! you won.");
    }
  }

  bool changeMoveState(String input) {
    step++;
    bool isMove = state.changeState(input);
    action = "Move";


    if (isMove) {
      // 移動できない場合はターンは更新しない。
      turn++;
    }
    return isMove;
  }

  bool changeAttackState(String input) {
    step++;
    turn++;
    action = "Attack";
    return true;
  }

  void nextStage() {
    _stage++;
    step = 0;
    state.changeStage(_stage);
  }
}
