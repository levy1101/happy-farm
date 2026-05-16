import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sproutvalley/models/blocks/collision_block.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/models/constants/render_priority.dart';
import 'package:sproutvalley/objects/characters/player/player_sprite.dart';
import 'package:sproutvalley/objects/environments/trees/leaves_sprite.dart';
import 'package:sproutvalley/sprout_valley.dart';

class TreeSprite extends SpriteAnimationComponent
    with HasGameReference<SproutValley> , CollisionCallbacks{

  late SpriteAnimation idleTree, shakeTree, fallTree;

  late CollisionBlock trunkHitbox;
  late CircleHitbox leaveHitbox;

  PlayerSprite? player;

  int hitTimes = 3;

  late Vector2 srcSize = Vector2(64, 48);

  TreeSprite({required Vector2 position}): super(
    position: position,
    priority: RenderPriority.ground,
    scale: Vector2(WORLD_SCALE + 0.5, WORLD_SCALE + 0.5)
  );

  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  @override
  // TODO: implement debugColor
  Color get debugColor => Colors.transparent;

  @override
  FutureOr<void> onLoad() async{
    await loadAssets();
    await loadHitbox();
    return super.onLoad();
  }


  @override
  void onMount() {
    super.onMount();
    callWhenPlayerIsAvailable();
  }

  @override
  void update(double dt) {
    super.update(dt);
    checkIfPlayerChopCollidingWithTrunk(dt);
  }

  callWhenPlayerIsAvailable() async {
    while(player == null){
      await Future.delayed(const Duration(milliseconds: 10));
      player = game.findByKeyName("player");
    }
  }

  loadAssets()async{
    await loadAssetTrees();
  }

  loadHitbox()async{
    trunkHitbox = CollisionBlock(
      size: Vector2(10, 6),
      position: Vector2(35, 35),
    );

    leaveHitbox = CircleHitbox(
      radius: 10,
      position: Vector2(30, 14),
      isSolid: true,
      collisionType: CollisionType.passive
    )..debugColor = Colors.transparent;


    await addAll([trunkHitbox, leaveHitbox]);
  }

  loadAssetTrees()async{
    idleTree = _createSpriteSheetAnimation("environments/trees/tree.png", length: 1, loop: false);
    shakeTree = _createSpriteSheetAnimation("environments/trees/tree.png", loop: false);
    fallTree = _createSpriteSheetAnimation("environments/trees/fall_tree.png", loop: false, spacing: 0, length: 12);

    animation = idleTree;
  }

  _createSpriteSheetAnimation(String name, {int length = 7, double stepTime = 0.1, bool loop = true, double spacing = 1}){
    return SpriteSheet(
        image: game.images.fromCache(name),
        srcSize: srcSize,
        spacing: spacing,
    ).createAnimation(
        row: 0,
        to: length,
        stepTime: stepTime,
      loop: loop
    );
  }

  checkIfPlayerChopCollidingWithTrunk(double dt){
    if(player != null && checkPlayerHitboxChopIsMounted()){
      if((trunkHitbox.collidingWith(player!.hitboxChopDown) ||
              trunkHitbox.collidingWith(player!.hitboxChopUp) ||
              trunkHitbox.collidingWith(player!.hitboxChopRight) ||
              trunkHitbox.collidingWith(player!.hitboxChopLeft))
      ){
        animateTreeShaking(dt);
      }
    }
  }

  checkPlayerHitboxChopIsMounted(){
    if((player!.hitboxChopDown != null && player!.hitboxChopDown!.isMounted) ||
        player!.hitboxChopUp != null && player!.hitboxChopUp!.isMounted ||
        player!.hitboxChopRight != null && player!.hitboxChopRight!.isMounted ||
        player!.hitboxChopLeft != null && player!.hitboxChopLeft!.isMounted){
      return true;
    }
    return false;
  }

  showLeaves(){
    var leaves1 = LeavesSprite(
        position: Vector2(position.x + (38 * WORLD_SCALE), position.y + (20 * WORLD_SCALE)));
    var leaves2 = LeavesSprite(
        position: Vector2(position.x + (48 * WORLD_SCALE), position.y + (20 * WORLD_SCALE)));
    if(position.y < player!.position.y){
      leaves1.priority = RenderPriority.maximum;
      leaves2.priority = RenderPriority.maximum;
    }
    parent?.addAll([leaves1, leaves2]);
  }

  animateTreeShaking(double dt){
    animation = shakeTree;

    if(animation != null && animationTicker != null){
      animationTicker!.onFrame = (indexFrame){
        if(indexFrame == 2){
          showLeaves();
        }
      };
      animationTicker!.onComplete = (){

        if(hitTimes <= 0){
          animateFallTree();
          return;
        }

        animation = idleTree;
        hitTimes--;
      };
    }
  }

  animateFallTree(){
    animation = fallTree;
    if(animation != null && animationTicker != null){
      animationTicker!.onComplete = (){
        removeAll([trunkHitbox, trunkHitbox]);
        removeFromParent();
      };
    }
  }

}