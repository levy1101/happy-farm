import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/models/constants/render_priority.dart';
import 'package:sproutvalley/scenes/worlds/farm/farm_world.dart';
import 'package:sproutvalley/scenes/worlds/house/house_world.dart';

class SproutValley extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection{

  late BuildContext gameContext;
  late CameraComponent cameraComponent;
  late RouterComponent router;

  late TiledComponent farmTiled, houseTiled;
  late PositionComponent farmMap, houseMap;

  late SpriteAnimationComponent waterFarmComponent;

  final imageCompiler = ImageBatchCompiler();

  String? nextRoute;
  String? prevRoute;

  int activeToolIndex = 0;
  bool wateringCanHasWater = false;
  final List<Vector2> waterPositions = [];

  final _keyboardController = StreamController<KeyEvent>.broadcast();
  Stream<KeyEvent> get keyboardEventStream => _keyboardController.stream;

  void initWithBuildContext(BuildContext context){
    gameContext = context;
  }

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await preRenderWorld();
    await loadRouterWorld();
    return super.onLoad();
  }

  loadRouterWorld()async{
    cameraComponent = CameraComponent();
    router = RouterComponent(routes: {
      'farm' : WorldRoute(
        () {
          final farmWorld = FarmWorld();
          cameraComponent.world = farmWorld;
          return farmWorld;
        },
        maintainState: false
      ),
      'house' : WorldRoute(
          (){
            final houseWorld = HouseWorld();
            cameraComponent.world = houseWorld;
            return houseWorld;
          },
        maintainState: false
      )
    }, initialRoute: 'farm', );

    await addAll([cameraComponent, router]);
  }

  preRenderWorld()async{
    await renderFarm();
    await renderHouse();
  }

  renderHouse()async{
    houseTiled = await TiledComponent.load(
        'house.tmx',
        Vector2.all(WORLD_TILE_SIZE),
        prefix: 'assets/tiles/house/',
        images: Images(prefix: 'assets/images/resources/'),
        priority: RenderPriority.ground
    );

    houseTiled.tileMap.map.height *= 16;
    houseTiled.tileMap.map.width *= 16;

    houseMap = imageCompiler.compileMapLayer(
        tileMap: houseTiled.tileMap,
        layerNames: [
          'floor',
          'walls',
          'furniture',
        ]
    );
    houseMap.priority = RenderPriority.ground;
  }

  renderFarm()async{
    farmTiled = await TiledComponent.load(
        'farm.tmx',
        Vector2.all(WORLD_TILE_SIZE),
        prefix: 'assets/tiles/farm/',
        images: Images(prefix: 'assets/images/resources/'),
        priority: RenderPriority.ground
    );

    farmTiled.tileMap.map.height *= 16;
    farmTiled.tileMap.map.width *= 16;

    farmMap = imageCompiler.compileMapLayer(
        tileMap: farmTiled.tileMap,
        layerNames: [
          'ground',
          'house_floor',
          'house_walls',
          'house_roofs'
        ]
    );
    farmMap.priority = RenderPriority.ground;

    final animationCompiler = AnimationBatchCompiler();
    waterPositions.clear();
    await TileProcessor.processTileType(
        tileMap: farmTiled.tileMap,
        processorByType: <String, TileProcessorFunc>{
          'water' : ((tile, position, size) async {
            waterPositions.add(position.clone());
            return animationCompiler.addTile(position, tile);
          })
        },
        layersToLoad: ['water']);

    waterFarmComponent = await animationCompiler.compile();
    waterFarmComponent.scale = Vector2.all(WORLD_SCALE);
    waterFarmComponent.priority = RenderPriority.water;
  }

  switchScene(String toRoute){
    nextRoute = toRoute;
    router.pushReplacementNamed(toRoute);
  }

  bool isNearWater(Vector2 playerPosition) {
    if (nextRoute == 'house' || (router.currentRoute?.name == 'house')) return false;
    for (final waterPos in waterPositions) {
      final scaledWaterPos = waterPos * WORLD_SCALE;
      final waterCenter = scaledWaterPos + Vector2.all(WORLD_TILE_SIZE / 2);
      final playerCenter = playerPosition + Vector2.all(48 * WORLD_SCALE / 2);
      final distance = playerCenter.distanceTo(waterCenter);
      if (distance < 96.0) {
        return true;
      }
    }
    return false;
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    _keyboardController.add(event);
    return KeyEventResult.ignored;
  }

  @override
  void onRemove() {
    _keyboardController.close();
    super.onRemove();
  }


}