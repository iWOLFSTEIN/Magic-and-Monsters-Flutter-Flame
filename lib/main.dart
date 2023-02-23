import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/buttons.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

enum LighteningMageState { idle, running, jump }

enum ButtonStates { up, down, left, right }

class MyGame extends FlameGame with HasDraggables {
  final background = SpriteComponent();
  late SpriteAnimationGroupComponent<LighteningMageState> lighteningMage;
  bool isPlayerFlipped = false;
  bool isPlayerJumped = false;
  late Button up;
  late Button down;
  late Button left;
  late Button right;

  @override
  Future<void> onLoad() async {
    background
      ..sprite = await loadSprite('bg1.png')
      ..size = Vector2(size[0], size[1]);
    add(background);

    var spriteSize = Vector2(128, 128);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 7, stepTime: 0.1, textureSize: spriteSize);

    final idle = SpriteAnimation.fromFrameData(
        await images.load('lm_idle.png'), spriteData);
    final running = SpriteAnimation.fromFrameData(
        await images.load('lm_run.png'), spriteData);
    final jump = SpriteAnimation.fromFrameData(
        await images.load('lm_jump.png'), spriteData);

    lighteningMage = SpriteAnimationGroupComponent<LighteningMageState>(
        animations: {
          LighteningMageState.idle: idle,
          LighteningMageState.running: running,
          LighteningMageState.jump: jump
        },
        current: LighteningMageState.idle,
        size: spriteSize,
        anchor: Anchor.center,
        position: Vector2(100, (size[1] / 1.3) + 7));

    add(lighteningMage);

    up = Button(
        button: 'arrow-up.png',
        marginLeft: size[0] - 110,
        marginTop: size[1] - 135);
    down = Button(
        button: 'arrow-down.png',
        marginLeft: size[0] - 110,
        marginTop: size[1] - 70);
    left = Button(
        button: 'arrow-left.png',
        marginLeft: size[0] - 145,
        marginTop: size[1] - 100);
    right = Button(
        button: 'arrow-right.png',
        marginLeft: size[0] - 75,
        marginTop: size[1] - 100);

    add(up);
    add(down);
    add(left);
    add(right);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (lighteningMage.y < (size[1] / 1.3) + 7) {
      lighteningMage.y += 100 * dt;
    }
    if (lighteningMage.current == LighteningMageState.running) {
      playerRunning(dt);
    } else if (isPlayerJumped) {
      lighteningMage.y = lighteningMage.y - 100;
      isPlayerJumped = false;
    }
  }

  playerRunning(double dt) {
    lighteningMage.current == LighteningMageState.running;
    if (isPlayerFlipped) {
      lighteningMage.x -= 130 * dt;
    } else if (!isPlayerFlipped) {
      lighteningMage.x += 130 * dt;
    }
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    // TODO: implement onDragStart
    super.onDragStart(pointerId, info);
    if (right.state) {
      if (isPlayerFlipped) {
        isPlayerFlipped = false;
        lighteningMage.flipHorizontally();
      }
      lighteningMage.current = LighteningMageState.running;
    } else if (left.state) {
      if (!isPlayerFlipped) {
        isPlayerFlipped = true;
        lighteningMage.flipHorizontally();
      }

      lighteningMage.current = LighteningMageState.running;
    } else if (up.state) {
      if (!isPlayerJumped && lighteningMage.y >= (size[1] / 1.3) + 7) {
        lighteningMage.current = LighteningMageState.jump;
        isPlayerJumped = true;
      }
    }
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    // TODO: implement onDragEnd
    super.onDragEnd(pointerId, info);
    if (lighteningMage.current == LighteningMageState.jump) {
      lighteningMage.animation!.loop = false;

      lighteningMage.animation!.onComplete = () {
        lighteningMage.animation!.reset();
        lighteningMage.current = LighteningMageState.idle;
      };
    } else {
      lighteningMage.current = LighteningMageState.idle;
    }
  }
}
