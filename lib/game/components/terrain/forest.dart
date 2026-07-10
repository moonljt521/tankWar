import 'package:flame/components.dart';
import '../../data/constants.dart';
import '../../utils/sprite_generator.dart';

class Forest extends PositionComponent {
  Forest({required Vector2 position}) 
      : super(
          position: position,
          size: Vector2(GameConstants.cellSize, GameConstants.cellSize),
          anchor: Anchor.center,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final img = await SpriteGenerator.getForest();
    add(SpriteComponent(
      size: size,
      sprite: Sprite(img),
    ));
  }
}