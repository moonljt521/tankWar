import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../data/constants.dart';
import '../../utils/sprite_generator.dart';

class Water extends PositionComponent with CollisionCallbacks {
  Water({required Vector2 position}) 
      : super(
          position: position,
          size: Vector2(GameConstants.cellSize, GameConstants.cellSize),
          anchor: Anchor.center,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final img = await SpriteGenerator.getWater();
    add(SpriteComponent(
      size: size,
      sprite: Sprite(img),
    ));
    add(RectangleHitbox());
  }
  
  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}