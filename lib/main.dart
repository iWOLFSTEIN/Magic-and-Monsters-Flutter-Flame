import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

enum LighteningMageState { idle, running }

enum ButtonStates { up, down, left, right }

class MyGame extends FlameGame with HasTappables {
  final background = SpriteComponent();
  late SpriteAnimationGroupComponent<LighteningMageState> lighteningMage;
  bool isPlayerFlipped = false;
  bool isPlayerJumped = false;
  late Button up;
  late Button down;
  late Button left;
  late Button right;

  late SpriteGroupComponent<ButtonStates> buttons;

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

    lighteningMage = SpriteAnimationGroupComponent<LighteningMageState>(
        animations: {
          LighteningMageState.idle: idle,
          LighteningMageState.running: running
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
    if (lighteningMage.current == LighteningMageState.running) {
      if (isPlayerFlipped
          //  && !isPlayerJumped
          ) {
        lighteningMage.x -= 130 * dt;
      } else if (!isPlayerFlipped
          //  && !isPlayerJumped
          ) {
        lighteningMage.x += 130 * dt;
      }
      // if (isPlayerJumped) {
      //   lighteningMage.y = lighteningMage.y - 20;
      //   Future.delayed(const Duration(milliseconds: 200), () {
      //     lighteningMage.y = lighteningMage.y + 20;
      //     isPlayerJumped = false;
      //   });
      // }
    }
  }

  // @override
  // void onDragEnd(int pointerId, DragEndInfo info) {
  //   // TODO: implement onDragEnd
  //   super.onDragEnd(pointerId, info);
  //   lighteningMage.current = LighteningMageState.idle;
  // }

  // @override
  // void onDragUpdate(int pointerId, DragUpdateInfo info) {
  //   // TODO: implement onDragUpdate
  //   super.onDragUpdate(pointerId, info);
  //   if (info.delta.game.x > 0) {
  //     if (isPlayerFlipped) {
  //       isPlayerFlipped = false;
  //       lighteningMage.flipHorizontally();
  //     }
  //     lighteningMage.current = LighteningMageState.running;
  //   } else if (info.delta.game.x < 0) {
  //     if (!isPlayerFlipped) {
  //       isPlayerFlipped = true;
  //       lighteningMage.flipHorizontally();
  //     }

  //     lighteningMage.current = LighteningMageState.running;
  //   } else if (info.delta.game.y < 0) {
  //     if (!isPlayerJumped) {
  //       isPlayerJumped = true;
  //     }
  //   }
  // }
}

class Button extends SpriteComponent with Tappable {
  Button({required this.button, this.marginLeft, this.marginTop})
      : super(size: Vector2.all(16));
  final String button;
  double? marginLeft;
  double? marginTop;
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(button);
    size = Vector2(50, 50);
    position = Vector2(marginLeft ?? 0, marginTop ?? 0);
  }

  @override
  bool onLongTapDown(TapDownInfo info) {
    // TODO: implement onLongTapDown
    print('something');
    return super.onLongTapDown(info);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    // TODO: implement onTapDown
    print('something');
    return super.onTapDown(info);
  }
}
