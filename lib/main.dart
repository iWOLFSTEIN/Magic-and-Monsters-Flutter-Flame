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

enum WanderingWizardStates {
  idle,
  running,
  jumping,
  arrowAttack,
  fireAttack,
  arrow,
  fire,
}

enum ButtonStates { up, down, left, right }

class MyGame extends FlameGame with HasDraggables {
  final background = SpriteComponent();
  late SpriteAnimationGroupComponent<WanderingWizardStates> wanderingWizard;
  bool isPlayerFlipped = false;
  bool isPlayerJumped = false;
  late Button up;
  late Button down;
  late Button left;
  late Button right;
  late Button arrowAttackBt;
  late Button fireAttackBt;
  late SpriteAnimationGroupComponent<WanderingWizardStates> fireAnimation;
  late SpriteAnimationGroupComponent<WanderingWizardStates> arrowAnimation;

  @override
  Future<void> onLoad() async {
    background
      ..sprite = await loadSprite('bg1.png')
      ..size = Vector2(size[0], size[1]);
    add(background);

    var spriteSize = Vector2(128, 128);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 7, stepTime: 0.1, textureSize: spriteSize);
    final arrowAttackSpriteData = SpriteAnimationData.sequenced(
        amount: 6, stepTime: 0.1, textureSize: spriteSize);
    final fireAttackSpriteData = SpriteAnimationData.sequenced(
      amount: 9,
      stepTime: 0.1,
      textureSize: spriteSize,
    );

    final idle = SpriteAnimation.fromFrameData(
        await images.load('wm_idle.png'), spriteData);
    final running = SpriteAnimation.fromFrameData(
        await images.load('wm_running.png'), spriteData);
    final jumping = SpriteAnimation.fromFrameData(
        await images.load('wm_jumping.png'), spriteData);

    final arrowAttack = SpriteAnimation.fromFrameData(
      await images.load('wm_arrow_attack.png'),
      arrowAttackSpriteData,
    );

    final fireAttack = SpriteAnimation.fromFrameData(
      await images.load('wm_fire_attack.png'),
      fireAttackSpriteData,
    );
    final fire = SpriteAnimation.fromFrameData(
      await images.load('fire.png'),
      spriteData,
    );
    final arrow = SpriteAnimation.fromFrameData(
      await images.load('arrow.png'),
      arrowAttackSpriteData,
    );

    fireAnimation = SpriteAnimationGroupComponent<WanderingWizardStates>(
        animations: {
          WanderingWizardStates.fire: fire,
        },
        current: null,
        size: spriteSize,
        anchor: Anchor.center,
        position: Vector2(200, (size[1] / 1.3) + 7));

    arrowAnimation = SpriteAnimationGroupComponent<WanderingWizardStates>(
        animations: {
          WanderingWizardStates.arrow: arrow,
        },
        current: null,
        size: spriteSize,
        anchor: Anchor.center,
        position: Vector2(200, (size[1] / 1.3) + 7));

    wanderingWizard = SpriteAnimationGroupComponent<WanderingWizardStates>(
        animations: {
          WanderingWizardStates.idle: idle,
          WanderingWizardStates.running: running,
          WanderingWizardStates.jumping: jumping,
          WanderingWizardStates.arrowAttack: arrowAttack,
          WanderingWizardStates.fireAttack: fireAttack,
        },
        current: WanderingWizardStates.idle,
        size: spriteSize,
        anchor: Anchor.center,
        position: Vector2(200, (size[1] / 1.3) + 7));

    add(wanderingWizard);

    directionControlButtons();

    add(up);
    add(down);
    add(left);
    add(right);
    add(arrowAttackBt);
    add(fireAttackBt);

    add(fireAnimation);
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

    arrowAttackBt = Button(
        button: 'arrow_attack_icon.png',
        sSize: 25,
        marginLeft: size[0] - 110,
        marginTop: size[1] - 145);
    fireAttackBt = Button(
        button: 'fire_attack_icon.png',
        sSize: 25,
        marginLeft: size[0] - 145,
        marginTop: size[1] - 110);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (wanderingWizard.y < (size[1] / 1.3) + 7) {
      wanderingWizard.y += 100 * dt;
    }
    if (wanderingWizard.current == WanderingWizardStates.running) {
      playerRunning(dt);
    } else if (isPlayerJumped) {
      wanderingWizard.y = wanderingWizard.y - 100 * 50 * dt;
      isPlayerJumped = false;
    }
  }

  playerRunning(double dt) {
    wanderingWizard.current == WanderingWizardStates.running;
    if (isPlayerFlipped) {
      wanderingWizard.x -= 130 * dt;
    } else if (!isPlayerFlipped) {
      wanderingWizard.x += 130 * dt;
    }
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    // TODO: implement onDragStart
    super.onDragStart(pointerId, info);
    if (right.state) {
      if (isPlayerFlipped) {
        isPlayerFlipped = false;
        wanderingWizard.flipHorizontally();
        fireAnimation.flipHorizontally();
      }
      wanderingWizard.current = WanderingWizardStates.running;
    } else if (left.state) {
      if (!isPlayerFlipped) {
        isPlayerFlipped = true;
        wanderingWizard.flipHorizontally();
        fireAnimation.flipHorizontally();
      }

      wanderingWizard.current = WanderingWizardStates.running;
    } else if (up.state) {
      if (!isPlayerJumped && wanderingWizard.y >= (size[1] / 1.3) + 7) {
        wanderingWizard.current = WanderingWizardStates.jumping;
        isPlayerJumped = true;
      }
    } else if (arrowAttackBt.state) {
      wanderingWizard.current = WanderingWizardStates.arrowAttack;
    } else if (fireAttackBt.state) {
      wanderingWizard.current = WanderingWizardStates.fireAttack;
    }
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    // TODO: implement onDragEnd
    super.onDragEnd(pointerId, info);
    if (wanderingWizard.current != WanderingWizardStates.running) {
      if (wanderingWizard.current == WanderingWizardStates.fireAttack) {
        attacksAnimations(fireAnimation, WanderingWizardStates.fire);
      } else if (wanderingWizard.current == WanderingWizardStates.arrowAttack) {
        attacksAnimations(arrowAnimation, WanderingWizardStates.arrow);
      } else {
        animationWait(wanderingWizard, WanderingWizardStates.idle);
      }
    } else {
      wanderingWizard.current = WanderingWizardStates.idle;
    }
  }

  attacksAnimations(animation, current) {
    animationWait(wanderingWizard, WanderingWizardStates.idle);
    animation.y = wanderingWizard.y + 25;
    if (isPlayerFlipped) {
      animation.x = wanderingWizard.x - 70;
    } else {
      animation.x = wanderingWizard.x + 70;
    }

    animation.current = current;
    animationWait(animation, null);
  }

  animationWait(
      SpriteAnimationGroupComponent animationId, WanderingWizardStates? state) {
    animationId.animation!.loop = false;
    animationId.animation!.onComplete = () {
      animationId.animation!.reset();

      animationId.current = state;
    };
  }
}
