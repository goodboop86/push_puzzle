import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:push_puzzle/utility/action_type.dart';

import 'components/player.dart';
import 'components/crate.dart';

import 'dart:async';

import 'src/push_game.dart';
import 'utility/config.dart';
import 'utility/action_key.dart';

class MainGame extends FlameGame with KeyboardEvents, HasGameRef {
  late Function stateCallbackHandler;

  PushGame pushGame = PushGame();
  late Player _player;
  final List<Crate> _crateList = [];
  final List<SpriteComponent> _bgComponentList = [];
  final List<SpriteComponent> _floorSpriteList = [];
  late Map<String, Sprite> _spriteMap;
  late Sprite _floorSprite;
  late final TextComponent turnText;
  late final TextComponent actionText;

  @override
  bool debugMode = true;

  @override
  Color backgroundColor() => const Color.fromRGBO(89, 106, 108, 1.0);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final blockSprite = await Sprite.load('block.png');
    final goalSprite = await Sprite.load('goal.png');
    _floorSprite = await Sprite.load('floor.png');
    _spriteMap = {
      '#': blockSprite,
      '.': goalSprite,
    };

    await draw();
    await debugDraw();
  }

  void setCallback(Function fn) => stateCallbackHandler = fn;

  Future<void> debugDraw() async {
    add(turnText = TextComponent(
      position: Vector2(10, 10),
      priority: 1,
      text: "0",
    ));
    add(actionText = TextComponent(
      position: Vector2(60, 10),
      priority: 1,
      text: "start",
    ));
  }

  Future<void> draw() async {
    for (var y = 0; y < pushGame.state.splitStageStateList.length; y++) {
      final row = pushGame.state.splitStageStateList[y];
      final firstWallIndex = row.indexOf('#');
      final lastWallIndex = row.lastIndexOf('#');

      for (var x = 0; x < row.length; x++) {
        final char = row[x];
        if (x > firstWallIndex && x < lastWallIndex)
          renderFloor(x.toDouble(), y.toDouble());
        if (_spriteMap.containsKey(char))
          renderBackGround(_spriteMap[char], x.toDouble(), y.toDouble());
        if (char == 'p') initPlayer(x.toDouble(), y.toDouble());
        if (char == 'o') initCrate(x.toDouble(), y.toDouble());
      }
    }

    add(_player);
    for (var crate in _crateList) {
      add(crate);
    }

    if (pushGame.state.width > playerCameraWallWidth) {
      camera.followComponent(_player);
    } else {
      camera.followVector2(Vector2(pushGame.state.width * oneBlockSize / 2,
          pushGame.state.height * oneBlockSize / 2));
      // final component = _bgComponentList.first;
      // camera.followComponent(component);
      // camera.setRelativeOffset(Anchor.center);
    }
  }

  void renderBackGround(sprite, double x, double y) {
    final component = SpriteComponent(
      size: Vector2.all(oneBlockSize),
      sprite: sprite,
      position: Vector2(x * oneBlockSize, y * oneBlockSize),
    );
    _bgComponentList.add(component);
    add(component);
  }

  void renderFloor(double x, double y) {
    final component = SpriteComponent(
      size: Vector2.all(oneBlockSize),
      sprite: _floorSprite,
      position: Vector2(x * oneBlockSize, y * oneBlockSize),
    );
    _floorSpriteList.add(component);
    add(component);
  }

  void initPlayer(double x, double y) {
    _player = Player();
    _player.position = Vector2(x * oneBlockSize, y * oneBlockSize);
  }

  void initCrate(double x, double y) {
    final crate = Crate();
    crate.setPosition(Vector2(x, y));
    crate.position = Vector2(x * oneBlockSize, y * oneBlockSize);
    _crateList.add(crate);
  }

  void allReset() {
    remove(_player);
    for (var crate in _crateList) {
      remove(crate);
    }
    for (var bg in _bgComponentList) {
      remove(bg);
    }
    for (var floorSprite in _floorSpriteList) {
      remove(floorSprite);
    }
    _crateList.clear();
    _bgComponentList.clear();
    _floorSpriteList.clear();
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    ActionKey keyAction = ActionKey.none;

    if (!isKeyDown || _player.moveCount != 0 || pushGame.state.isClear) {
      return super.onKeyEvent(event, keysPressed);
    }

    keyAction = getKeyAction(event);
    ActionType actionType = getActionType(keyAction.name);

    if (actionType == ActionType.move) {
      bool isMove = pushGame.changeMoveState(keyAction.name);
      if (isMove) {
        playerMoveAction(isKeyDown, keyAction);
        turnText.text = pushGame.turn.toString();
        actionText.text = pushGame.action.toString();
        if (pushGame.state.isCrateMove) {
          crateMove();
        }
        if (pushGame.state.isClear) {
          stateCallbackHandler(pushGame.state.isClear);
          Timer(const Duration(seconds: 3), drawNextStage);
        }
      }
    } else if (actionType == ActionType.attack) {
      bool isAttack = pushGame.changeAttackState(keyAction.name);
      if (isAttack) {
        playerAttackAction(isKeyDown, keyAction);
        turnText.text = pushGame.turn.toString();
        actionText.text = pushGame.action.toString();
      }
    }
    else if (actionType == ActionType.rest) {
      bool isRest = pushGame.changeRestState(keyAction.name);
      if (isRest) {
        playerRestAction(isKeyDown, keyAction);
        turnText.text = pushGame.turn.toString();
        actionText.text = pushGame.action.toString();
      }
    }

    return super.onKeyEvent(event, keysPressed);

  }

  ActionKey getKeyAction(RawKeyEvent event) {
    ActionKey keyAction = ActionKey.none;
    if (event.logicalKey == LogicalKeyboardKey.keyA ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      keyAction = ActionKey.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      keyAction = ActionKey.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      keyAction = ActionKey.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      keyAction = ActionKey.down;
    } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
      keyAction = ActionKey.r;
    }
    // spaceの場合
    else if (event.logicalKey == LogicalKeyboardKey.findKeyByKeyId(0x00000000020)) {
      keyAction = ActionKey.space;
    }
    print(keyAction.name.toString());
    return keyAction;
  }

  void playerMoveAction(bool isKeyDown, ActionKey keyDirection) {
    if (isKeyDown && keyDirection != ActionKey.none) {
      _player.direction = keyDirection;
      _player.moveCount = oneBlockSize.toInt();
    } else if (_player.direction == keyDirection) {
      _player.direction = ActionKey.none;
    }
  }

  void playerAttackAction(bool isKeyDown, ActionKey keyDirection) {
    print("attack!!!");
  }

  void playerRestAction(bool isKeyDown, ActionKey keyDirection) {
    print("rest...");
  }



  void crateMove() {
    final targetCrate = _crateList.firstWhere(
        (crate) => crate.coordinate == pushGame.state.crateMoveBeforeVec);
    targetCrate.move(pushGame.state.crateMoveAfterVec);
    targetCrate.goalCheck(pushGame.state.goalVecList);
  }

  void drawNextStage() {
    pushGame.nextStage();
    stateCallbackHandler(pushGame.state.isClear);
    allReset();
    draw();
  }
}
