import 'package:get_it/get_it.dart';
import 'package:sproutvalley/game_instance.dart';

final getIt = GetIt.instance;

Future init()async{
  await getIt<GameInstance>().setupGame();
}