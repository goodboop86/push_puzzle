import 'package:flame/components.dart';

enum ActionType {move, attack, other}

ActionType getActionType(String input) {
  switch (input) {
    case 'left':
      return ActionType.move;
    case 'right':
      return ActionType.move;
    case 'up':
      return ActionType.move;
    case 'down':
      return ActionType.move;
    case 'space':
      return ActionType.attack;
  }
  return ActionType.other;
}