import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sproutvalley/models/constants/global_constants.dart';
import 'package:sproutvalley/sprout_valley.dart';

class ToolboxOverlays extends StatefulWidget {

  final SproutValley game;

  const ToolboxOverlays({super.key, required this.game});

  @override
  State<ToolboxOverlays> createState() => _ToolboxOverlaysState();
}

class _ToolboxOverlaysState extends State<ToolboxOverlays> {

  late SproutValley game;

  var panelHeight = 310.0;
  var panelWidth = 36.0;

  int selectIndex = 0;

  late StreamSubscription<KeyEvent> _keyboardSub;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game = widget.game;

    _keyboardSub = game.keyboardEventStream.listen(_handleKey);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      onDispose();
    },);
    super.dispose();
  }

  void onDispose(){
    _keyboardSub.cancel();
  }

  void _handleKey(KeyEvent key){
    if(key is KeyDownEvent){
      if(key.logicalKey == LogicalKeyboardKey.keyE){
        if(selectIndex + 1 == 10){
          selectIndex = 0;
        }else{
          selectIndex++;
        }
      }else if(key.logicalKey == LogicalKeyboardKey.keyQ){
        if(selectIndex == 0){
          selectIndex = 9;
        }else{
          selectIndex--;
        }
      }
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    double scale = 2.0;
    double actualWidth = panelHeight * scale; // 310 * 2 = 620
    double actualHeight = panelWidth * scale; // 36 * 2 = 72

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        // FittedBox scales down the UI to fit the screen if it's narrower than 620px, ensuring all 10 slots are visible
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: actualWidth,
            height: actualHeight,
            child: Stack(
              children: [
                // 1. Background panel image (Contains exactly 10 slots)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: panelHeight,
                      height: panelWidth,
                      child: SpriteWidget(
                        sprite: Sprite(
                          game.images.fromCache('overlays/toolbox_overlays.png'),
                          srcSize: Vector2(panelHeight, panelWidth),
                        ),
                      ),
                    ),
                  ),
                ),
                // 2. Selector (Slides across based on standard pixel formula)
                Positioned(
                  // Background length is 310px. Left wooden margin is 4px. Each slot spacing is 30px.
                  // 4 + (10 slots * 30px) = 304, leaving 6px for the right wooden margin drop shadow -> Matches 310px!
                  left: (5.0 + selectIndex * 30.0) * scale, 
                  top: ((panelWidth - 28.0) / 2) * scale,   // (36 - 28)/2 = 4px (vertically centered)
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 30.0,
                      height: 28.0,
                      child: SpriteWidget(
                        sprite: Sprite(
                          game.images.fromCache('overlays/toolbox_selector_overlays.png'),
                          srcSize: Vector2(30.0, 28.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
