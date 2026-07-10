import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../data/constants.dart';
import '../utils/sprite_generator.dart';
import '../tank_war_game.dart';

class Base extends PositionComponent with CollisionCallbacks, HasGameReference<TankWarGame> {
  bool isDestroyed = false;
  
  Base({required Vector2 position}) 
      : super(
          position: position,
          size: Vector2(GameConstants.cellSize * 2, GameConstants.cellSize * 2),
          anchor: Anchor.center,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final img = await SpriteGenerator.getBase();
    add(SpriteComponent(
      size: size,
      sprite: Sprite(img),
    ));
    add(RectangleHitbox());
  }
  
  void destroy() {
    if (isDestroyed) return;
    isDestroyed = true;
    game.gameOver();
  }
  
  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}