import 'package:flame/components.dart';

enum KeyAction {up, down, left, right, none, attack}

Vector2 getActionDirection(String input) {
  double dx, dy;
  dx = dy = 0;

  switch (input) {
    case 'left':
      dx = -1;
      break;
    case 'right':
      dx = 1;
      break;
    case 'up':
      dy = -1;
      break;
    case 'down':
      dy = 1;
      break;
    case 'attack':
      // 進行方向の概念がないので、ひとまず上方向に少し移動する。
      dy = 0.5;
  }
  return Vector2(dx, dy);
}
