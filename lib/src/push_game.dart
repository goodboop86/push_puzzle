import 'stage_state.dart';

class PushGame {
  late int _stage;
  late int step;
  late int turn;
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
    changeState(input);
    draw();
    if (state.isClear) {
      print("Congratulation's! you won.");
    }
  }

  bool changeState(String input) {
    step++;

    bool isAttack = false;
    bool isMove = false;

    // 攻撃、移動の場合はactionを更新したい。
    if(input=='attack') {
      isAttack = true;
    } else {
      isMove = state.changeState(input);
    }

    if (isMove || isAttack) {
      // 移動や攻撃できない場合はターンは更新しない。
      turn++;
    }

    return isMove || isAttack;
  }

  void nextStage() {
    _stage++;
    step = 0;
    state.changeStage(_stage);
  }
}
