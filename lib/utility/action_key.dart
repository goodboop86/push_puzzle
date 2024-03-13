import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum ActionKey {up, down, left, right, none, space, r}

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
  }
  return Vector2(dx, dy);
}
