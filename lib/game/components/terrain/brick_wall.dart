import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../data/constants.dart';
import '../../utils/sprite_generator.dart';

class BrickWall extends PositionComponent with CollisionCallbacks {
  double health = 50;
  
  BrickWall({required Vector2 position}) 
      : super(
          position: position,
          size: Vector2(GameConstants.cellSize, GameConstants.cellSize),
          anchor: Anchor.center,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final img = await SpriteGenerator.getBrickWall();
    add(SpriteComponent(
      size: size,
      sprite: Sprite(img),
    ));
    add(RectangleHitbox());
  }
  
  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      removeFromParent();
    }
  }
  
  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}