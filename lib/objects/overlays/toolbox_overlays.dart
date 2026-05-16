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

  selectorWidget(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 20, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(var i = 0; i < 10; i++)
              Container(
                padding: const EdgeInsets.only(left: 10, right: 20),
                margin: const EdgeInsets.only(bottom: 4),
                child: Transform.scale(
                    scale: 2.0,
                    child: selectIndex == i ? SpriteWidget(
                      sprite: Sprite(
                        srcSize: Vector2(30, 28),
                        game.images.fromCache('overlays/toolbox_selector_overlays.png'),
                      ),
                    ) : const SizedBox(
                      height: 28,
                      width: 30,
                    )
                ),
              ),
          ],
        )
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Transform.scale(
              scale: 2.0,
              child: SpriteWidget(
                  sprite: Sprite(
                    srcSize: Vector2(panelHeight, panelWidth),
                    game.images.fromCache('overlays/toolbox_overlays.png'),
                  ),
              )
            ),
          ),
        ),
        selectorWidget()
      ],
    );
  }
}
