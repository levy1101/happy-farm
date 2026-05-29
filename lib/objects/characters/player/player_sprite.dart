import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sproutvalley/models/blocks/collision_block.dart';
import 'package:sproutvalley/models/blocks/intersection_block.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/models/constants/interact_name.dart';
import 'package:sproutvalley/models/constants/render_priority.dart';
import 'package:sproutvalley/models/enums/direction.dart';
import 'package:sproutvalley/models/enums/object_state.dart';
import 'package:sproutvalley/sprout_valley.dart';

class PlayerSprite extends SpriteAnimationComponent
    with HasGameReference<SproutValley>, CollisionCallbacks{

  PlayerSprite({required Vector2 position, required Vector2 size}) : super(
    key: ComponentKey.named("player"),
    position: position,
    size: size,
    priority: RenderPriority.player,
    scale: Vector2(WORLD_SCALE, WORLD_SCALE)
  );

  late SpriteAnimation idleDownAnimation, idleUpAnimation, idleLeftAnimation, idleRightAnimation;
  late SpriteAnimation walkDownAnimation, walkUpAnimation, walkLeftAnimation, walkRightAnimation;
  late SpriteAnimation chopDownAnimation, chopUpAnimation, chopLeftAnimation, chopRightAnimation;
  late SpriteAnimation tilingDownAnimation, tilingUpAnimation, tilingLeftAnimation, tilingRightAnimation;
  late SpriteAnimation wateringDownAnimation, wateringUpAnimation, wateringLeftAnimation, wateringRightAnimation;

  // hitbox chopp
  RectangleHitbox? hitboxChopDown, hitboxChopUp, hitboxChopRight, hitboxChopLeft;

  bool chopping = false;
  double chopDuration = 0.6;
  double chopTimer = 0.0;

  bool tiling = false;
  double tilingDuration = 0.6;
  double tilingTimer = 0.0;

  bool watering = false;
  double wateringDuration = 0.6;
  double wateringTimer = 0.0;

  Vector2 srcSize = Vector2(48, 48);

  Vector2 lastPosition = Vector2.zero();

  late RectangleHitbox baseHitbox;
  late IntersectionBlock intersectionBlock;

  double movementSpeed = 200;

  PlayerState state = PlayerState.idle;
  PlayerDirection direction = PlayerDirection.down;

  final Map<LogicalKeyboardKey, int> _keyWeight = {
    LogicalKeyboardKey.keyW : 0,
    LogicalKeyboardKey.keyA : 0,
    LogicalKeyboardKey.keyS : 0,
    LogicalKeyboardKey.keyD : 0
  };

  @override
  bool get debugMode => true;

  @override
  // TODO: implement debugColor
  Color get debugColor => Colors.transparent;

  @override
  FutureOr<void> onLoad() async{
    await loadAssets();
    await loadInputs();
    await loadHitbox();
    return super.onLoad();
  }


  @override
  void update(double dt) {
    _playerMove(dt);
    _handleChoppingTimer(dt);
    _handleTilingTimer(dt);
    _handleWateringTimer(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    if(other is CollisionBlock){
      onCollisionWalls(intersectionPoints);
    }else if(other is IntersectionBlock){
      onIntersectionCollisions(other);
    }
    super.onCollision(intersectionPoints, other);
  }


  loadAssets()async{
    idleDownAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_down.png");
    idleUpAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_up.png");
    idleLeftAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_left.png");
    idleRightAnimation = _createSpriteSheetAnimation("characters/players/idle/player_idle_right.png");

    walkDownAnimation = _createSpriteSheetAnimation("characters/players/walk/player_walk_down.png");
    walkUpAnimation  = _createSpriteSheetAnimation("characters/players/walk/player_walk_up.png");
    walkLeftAnimation  = _createSpriteSheetAnimation("characters/players/walk/player_walk_left.png");
    walkRightAnimation  = _createSpriteSheetAnimation("characters/players/walk/player_walk_right.png");

    chopDownAnimation = _createSpriteSheetAnimation("characters/players/choping/player_choping_down.png");
    chopUpAnimation  = _createSpriteSheetAnimation("characters/players/choping/player_choping_up.png");
    chopLeftAnimation  = _createSpriteSheetAnimation("characters/players/choping/player_choping_left.png");
    chopRightAnimation  = _createSpriteSheetAnimation("characters/players/choping/player_choping_right.png");

    tilingDownAnimation = _createSpriteSheetAnimation("characters/players/tiling/player_tiling_down.png");
    tilingUpAnimation  = _createSpriteSheetAnimation("characters/players/tiling/player_tiling_up.png");
    tilingLeftAnimation  = _createSpriteSheetAnimation("characters/players/tiling/player_tiling_left.png");
    tilingRightAnimation  = _createSpriteSheetAnimation("characters/players/tiling/player_tiling_right.png");

    wateringDownAnimation = _createSpriteSheetAnimation("characters/players/watering/player_watering_down.png");
    wateringUpAnimation  = _createSpriteSheetAnimation("characters/players/watering/player_watering_up.png");
    wateringLeftAnimation  = _createSpriteSheetAnimation("characters/players/watering/player_watering_left.png");
    wateringRightAnimation  = _createSpriteSheetAnimation("characters/players/watering/player_watering_right.png");


    animation = idleDownAnimation;
  }


  _createSpriteSheetAnimation(String name, {int length = 7, double stepTime = 0.1}){
    return SpriteSheet(
      image: game.images.fromCache(name),
      srcSize: srcSize,
      spacing: 1
    ).createAnimation(row: 0, to: length, stepTime: stepTime);
  }

  loadHitbox()async{
    baseHitbox = RectangleHitbox(
      position: Vector2(24,30),
      size: Vector2(10, 5),
      anchor: Anchor.bottomCenter
    )..debugColor = Colors.transparent;
    await add(baseHitbox);

    intersectionBlock = IntersectionBlock(
        name: "playerIntersection",
        position: Vector2(24,30),
        size: Vector2(10, 5),
        anchor: Anchor.bottomCenter
    );

    await add(intersectionBlock);
  }

  onCollisionWalls(Set<Vector2> onCollisionWalls){
    if(direction == PlayerDirection.up || direction == PlayerDirection.down){
      position.y = lastPosition.y;
    }else if(direction == PlayerDirection.left || direction == PlayerDirection.right){
      position.x = lastPosition.x;
    }
  }

  onIntersectionCollisions(IntersectionBlock other){
    switch(other.name){
      case InteractName.farmDoorToHouse:
        game.prevRoute = "farm";
        game.switchScene("house");
        break;
      case InteractName.houseDoorToFarm:
        game.prevRoute = "house";
        game.switchScene("farm");
        break;
    }
  }

  loadInputs()async{
    await add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.keyA : (key) =>
            _handleKey(LogicalKeyboardKey.keyA, false),
          LogicalKeyboardKey.keyW : (key) =>
              _handleKey(LogicalKeyboardKey.keyW, false),
          LogicalKeyboardKey.keyS : (key) =>
              _handleKey(LogicalKeyboardKey.keyS, false),
          LogicalKeyboardKey.keyD : (key) =>
              _handleKey(LogicalKeyboardKey.keyD, false),
          LogicalKeyboardKey.keyK : (key) =>
              _handleActionButton(false, "K"),
        },
        keyDown: {
          LogicalKeyboardKey.keyA : (key) =>
              _handleKey(LogicalKeyboardKey.keyA, true),
          LogicalKeyboardKey.keyW : (key) =>
              _handleKey(LogicalKeyboardKey.keyW, true),
          LogicalKeyboardKey.keyS : (key) =>
              _handleKey(LogicalKeyboardKey.keyS, true),
          LogicalKeyboardKey.keyD : (key) =>
              _handleKey(LogicalKeyboardKey.keyD, true),
          LogicalKeyboardKey.keyK : (key) =>
              _handleActionButton(true, "K"),
        }
      )
    );
  }

  _handleKey(LogicalKeyboardKey key, bool isDown){
    _keyWeight[key] = isDown ? 1 : 0;
    return true;
  }

  int get xInputKey =>
      _keyWeight[LogicalKeyboardKey.keyD]! - _keyWeight[LogicalKeyboardKey.keyA]!;
  int get yInputKey =>
      _keyWeight[LogicalKeyboardKey.keyS]! - _keyWeight[LogicalKeyboardKey.keyW]!;

  bool _handleActionButton(bool isDown, String key){
    if (key == "K") {
      switch(game.activeToolIndex){
        case 1:
          _handleActionTiling(isDown);
          break;
        case 2:
          _handleActionChopping(isDown);
          break;
        case 3:
          if (isDown) {
            if (game.isNearWater(position)) {
              game.wateringCanHasWater = true;
              _handleActionWatering(true);
            } else if (game.wateringCanHasWater) {
              _handleActionWatering(true);
              game.wateringCanHasWater = false;
            }
          } else {
            _handleActionWatering(false);
          }
          break;
        default:
          break;
      }
    }

    return true;
  }

  _handleActionChopping(bool isDown){
    if(isDown && state != PlayerState.chopping){
      state = PlayerState.chopping;
      chopTimer = chopDuration;
    }

    chopping = isDown;
  }

  _handleChoppingTimer(double dt){
    if(state == PlayerState.chopping){
      chopTimer -= dt;
      _handleChoppingHitbox(dt);
      if(chopTimer <= 0 && !chopping){
        state = PlayerState.idle;
      }
    }
  }

  _handleChoppingHitbox(double dt){
    if(animation != null && animationTicker != null){
      animationTicker!.onFrame = (frameIndex){
        if(frameIndex == 4){
          switch(direction){
            case PlayerDirection.down:
              hitboxChopDown = RectangleHitbox(
                position: Vector2(20,32),
                size: Vector2(5, 5),
              )..debugColor = Colors.transparent;
              add(hitboxChopDown!);
              break;
            case PlayerDirection.up:
              hitboxChopUp = RectangleHitbox(
                position: Vector2(25,10),
                size: Vector2(5, 5),
              )..debugColor = Colors.transparent;;
              add(hitboxChopUp!);
              break;
            case PlayerDirection.right:
              hitboxChopRight = RectangleHitbox(
                position: Vector2(30,27),
                size: Vector2(5, 5),
              )..debugColor = Colors.transparent;;
              add(hitboxChopRight!);
              break;
            case PlayerDirection.left:
              hitboxChopLeft = RectangleHitbox(
                position: Vector2(13,27),
                size: Vector2(5, 5),
              )..debugColor = Colors.transparent;;
              add(hitboxChopLeft!);
              break;
            default:
              break;
          }
        }else if(frameIndex == 6){
          removeAllChopHitbox();
        }
      };
    }
  }

  removeAllChopHitbox(){
    if(hitboxChopDown != null && hitboxChopDown!.isMounted) remove(hitboxChopDown!);
    if(hitboxChopUp != null && hitboxChopUp!.isMounted) remove(hitboxChopUp!);
    if(hitboxChopLeft != null && hitboxChopLeft!.isMounted) remove(hitboxChopLeft!);
    if(hitboxChopRight != null && hitboxChopRight!.isMounted) remove(hitboxChopRight!);

  }

  _handleActionTiling(bool isDown){
    if(isDown && state != PlayerState.tiling){
      state = PlayerState.tiling;
      tilingTimer = tilingDuration;
    }

    tiling = isDown;
  }

  _handleTilingTimer(double dt){
    if(state == PlayerState.tiling){
      tilingTimer -= dt;

      if(tilingTimer <= 0 && !tiling){
        state = PlayerState.idle;
      }
    }
  }

  _handleActionWatering(bool isDown){
    if(isDown && state != PlayerState.watering){
      state = PlayerState.watering;
      wateringTimer = wateringDuration;
    }

    watering = isDown;
  }

  _handleWateringTimer(double dt){
    if(state == PlayerState.watering){
      wateringTimer -= dt;

      if(wateringTimer <= 0 && !watering){
        state = PlayerState.idle;
      }
    }
  }


  _playerMove(double dt){

    lastPosition.setFrom(position);

    _handleActionAnimations();

    if(_reasonPlayerStop()){
      return;
    }

    if(xInputKey == -1 && yInputKey == 0){
      _walkLeft(dt);
    }else if(xInputKey == 1 && yInputKey == 0){
      _walkRight(dt);
    }else if(xInputKey == 0 && yInputKey == 1){
      _walkDown(dt);
    }else if(xInputKey == 0 && yInputKey == -1){
      _walkUp(dt);
    }else{
      _idle(dt);
    }

  }

  bool _reasonPlayerStop(){
    if(chopTimer > 0){
      return true;
    }

    if(tilingTimer > 0){
      return true;
    }

    if(wateringTimer > 0){
      return true;
    }

    return false;
  }

  _handleActionAnimations(){
    if(state == PlayerState.chopping){
      switch(direction){
        case PlayerDirection.down:
          animation = chopDownAnimation;
          break;
        case PlayerDirection.up:
          animation = chopUpAnimation;
          break;
        case PlayerDirection.left:
          animation = chopLeftAnimation;
          break;
        case PlayerDirection.right:
          animation = chopRightAnimation;
          break;
        default:
          break;
      }
    } else if(state == PlayerState.tiling){
      switch(direction){
        case PlayerDirection.down:
          animation = tilingDownAnimation;
          break;
        case PlayerDirection.up:
          animation = tilingUpAnimation;
          break;
        case PlayerDirection.left:
          animation = tilingLeftAnimation;
          break;
        case PlayerDirection.right:
          animation = tilingRightAnimation;
          break;
        default:
          break;
      }
    } else if(state == PlayerState.watering){
      switch(direction){
        case PlayerDirection.down:
          animation = wateringDownAnimation;
          break;
        case PlayerDirection.up:
          animation = wateringUpAnimation;
          break;
        case PlayerDirection.left:
          animation = wateringLeftAnimation;
          break;
        case PlayerDirection.right:
          animation = wateringRightAnimation;
          break;
        default:
          break;
      }
    }
  }

  _idle(dt){
    state = PlayerState.idle;
    switch(direction){
      case PlayerDirection.down:
        return _idleDown();
      case PlayerDirection.up:
        return _idleUp();
      case PlayerDirection.right:
        return _idleRight();
      case PlayerDirection.left:
        return _idleLeft();
      default:
        return _idleDown();

    }
  }

  _idleDown(){
    animation = idleDownAnimation;
  }

  _idleUp(){
    animation = idleUpAnimation;
  }

  _idleRight(){
    animation = idleRightAnimation;
  }

  _idleLeft(){
    animation = idleLeftAnimation;
  }

  _walkLeft(double dt){
    position.x += movementSpeed * dt * -1;
    animation = walkLeftAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.left;
  }

  _walkRight(double dt){
    position.x += movementSpeed * dt * 1;
    animation = walkRightAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.right;
  }

  _walkUp(double dt){
    position.y += movementSpeed * dt * -1;
    animation = walkUpAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.up;
  }

  _walkDown(double dt){
    position.y += movementSpeed * dt * 1;
    animation = walkDownAnimation;
    state = PlayerState.walk;
    direction = PlayerDirection.down;
  }
}