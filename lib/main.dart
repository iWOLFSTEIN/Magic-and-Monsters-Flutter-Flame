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

enum LighteningMageState {
  idle,
  running,
  jump,
  attack,
  lightCharge,
  charge,
}

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
  late Button attackBt;
  late Button lightChargeBt;
  late SpriteAnimationGroupComponent<LighteningMageState> lighteningCharge;

  @override
  Future<void> onLoad() async {
    background
      ..sprite = await loadSprite('bg1.png')
      ..size = Vector2(size[0], size[1]);
    add(background);

    var spriteSize = Vector2(128, 128);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 7, stepTime: 0.1, textureSize: spriteSize);
    final attackSpriteData = SpriteAnimationData.sequenced(
        amount: 10, stepTime: 0.1, textureSize: spriteSize);
    final lightChargeSpriteData = SpriteAnimationData.sequenced(
        amount: 9, stepTime: 0.1, textureSize: spriteSize);

    final idle = SpriteAnimation.fromFrameData(
        await images.load('lm_idle.png'), spriteData);
    final running = SpriteAnimation.fromFrameData(
        await images.load('lm_run.png'), spriteData);
    final jump = SpriteAnimation.fromFrameData(
        await images.load('lm_jump.png'), spriteData);
    final attack = SpriteAnimation.fromFrameData(
      await images.load('lm_attack.png'),
      attackSpriteData,
    );
    final lightCharge = SpriteAnimation.fromFrameData(
      await images.load('lm_light_ball.png'),
      spriteData,
    );
    final charge = SpriteAnimation.fromFrameData(
      await images.load('charge.png'),
      lightChargeSpriteData,
    );

    lighteningCharge = SpriteAnimationGroupComponent<LighteningMageState>(
        animations: {
          LighteningMageState.charge: charge,
        },
        current: LighteningMageState.idle,
        size: spriteSize,
        anchor: Anchor.center,
        position: Vector2(200, (size[1] / 1.3) + 7));

    lighteningMage = SpriteAnimationGroupComponent<LighteningMageState>(
        animations: {
          LighteningMageState.idle: idle,
          LighteningMageState.running: running,
          LighteningMageState.jump: jump,
          LighteningMageState.attack: attack,
          LighteningMageState.lightCharge: lightCharge
        },
        current: LighteningMageState.idle,
        size: spriteSize,
        anchor: Anchor.center,
        position: Vector2(200, (size[1] / 1.3) + 7));

    add(lighteningMage);

    directionControlButtons();

    add(up);
    add(down);
    add(left);
    add(right);
    add(attackBt);
    add(lightChargeBt);
    add(lighteningCharge);
  }

  directionControlButtons() {
    up = Button(
        button: 'arrow-up.png',
        marginLeft:
            //  size[0] - 110,
            80,
        marginTop: size[1] - 145);
    down = Button(
        button: 'arrow-down.png',
        marginLeft:
            //  size[0] - 110,
            80,
        marginTop: size[1] - 80);
    left = Button(
        button: 'arrow-left.png',
        marginLeft:
            //  size[0] -145,
            45,
        marginTop: size[1] - 110);
    right = Button(
        button: 'arrow-right.png',
        marginLeft:
            //  size[0] - 75,
            115,
        marginTop: size[1] - 110);

    attackBt = Button(
        button: 'attack.png',
        sSize: 25,
        marginLeft: size[0] - 110,
        marginTop: size[1] - 145);
    lightChargeBt = Button(
        button: 'bolt.png',
        sSize: 25,
        marginLeft: size[0] - 145,
        marginTop: size[1] - 110);
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
      lighteningMage.y = lighteningMage.y - 100 * 50 * dt;
      isPlayerJumped = false;
    }
    // else if (lighteningMage.current == LighteningMageState.lightCharge) {
    //   lighteningMage.x += 20 * dt;
    // }
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
        lighteningCharge.flipHorizontally();
      }
      lighteningMage.current = LighteningMageState.running;
    } else if (left.state) {
      if (!isPlayerFlipped) {
        isPlayerFlipped = true;
        lighteningMage.flipHorizontally();
        lighteningCharge.flipHorizontally();
      }

      lighteningMage.current = LighteningMageState.running;
    } else if (up.state) {
      if (!isPlayerJumped && lighteningMage.y >= (size[1] / 1.3) + 7) {
        lighteningMage.current = LighteningMageState.jump;
        isPlayerJumped = true;
      }
    } else if (attackBt.state) {
      lighteningMage.current = LighteningMageState.attack;
    } else if (lightChargeBt.state) {
      lighteningMage.current = LighteningMageState.lightCharge;
      // try {
      //   lighteningMage.current = null;
      // } catch (e) {
      //   print(e.toString());
      // }
    }
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    // TODO: implement onDragEnd
    super.onDragEnd(pointerId, info);
    if (lighteningMage.current != LighteningMageState.running) {
      if (lighteningMage.current != LighteningMageState.lightCharge) {
        animationWait(lighteningMage, LighteningMageState.idle);
      } else {
        animationWait(lighteningMage, LighteningMageState.idle);
        // lighteningCharge.x = lighteningMage.x + 70;
        lighteningCharge.y = lighteningMage.y + 45;
        if (isPlayerFlipped) {
          lighteningCharge.x = lighteningMage.x - 70;
        } else {
          lighteningCharge.x = lighteningMage.x + 70;
        }

        lighteningCharge.current = LighteningMageState.charge;
        animationWait(lighteningCharge, null);
      }
    } else {
      lighteningMage.current = LighteningMageState.idle;
    }
  }

  animationWait(
      SpriteAnimationGroupComponent animationId, LighteningMageState? state) {
    animationId.animation!.loop = false;
    animationId.animation!.onComplete = () {
      animationId.animation!.reset();

      animationId.current = state;
    };
  }
}
