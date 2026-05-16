import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sproutvalley/managers/game_manager.dart';
import 'package:sproutvalley/managers/player_manager.dart';
import 'package:sproutvalley/objects/overlays/toolbox_overlays.dart';
import 'package:sproutvalley/sprout_valley.dart';

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider<GameManager>(create: (context) => GameManager(),),
        ChangeNotifierProvider<PlayerManager>(create: (context) => PlayerManager(),)
      ],
      child: Consumer<GameManager>(
        builder: (context, value, child) {
          return const MyApp();
        },
      )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprout Valley',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: GameWidget(
        game: SproutValley()..initWithBuildContext(context),
        overlayBuilderMap: {
            'toolbox_panel' : (context, SproutValley game) => ToolboxOverlays(game: game)
        },
      ),
    );
  }
}
