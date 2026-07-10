import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../data/constants.dart';
import '../utils/sprite_generator.dart';
import 'tanks/tank.dart';
import 'tanks/player_tank.dart';
import 'tanks/enemy_tank.dart';
import 'terrain/brick_wall.dart';
import 'terrain/steel_wall.dart';
import 'base.dart';
import '../tank_war_game.dart';

class Bullet extends SpriteComponent with CollisionCallbacks, HasGameReference<TankWarGame> {
  final Direction direction;
  final Tank owner;
  final double damage = 25;
  final double speed = GameConstants.bulletSpeed;
  
  Bullet({
    required Vector2 position,
    required this.direction,
    required this.owner,
  }) : super(
    position: position,
    size: Vector2(8, 8),
    anchor: Anchor.center,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final img = await SpriteGenerator.getBullet(direction);
    sprite = Sprite(img);
    
    add(RectangleHitbox());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    switch (direction) {
      case Direction.up:
        position.y -= speed * dt;
        break;
      case Direction.down:
        position.y += speed * dt;
        break;
      case Direction.left:
        position.x -= speed * dt;
        break;
      case Direction.right:
        position.x += speed * dt;
        break;
    }
    
    if (position.x < -50 || position.x > GameConstants.gameWidth + 50 ||
        position.y < -50 || position.y > GameConstants.gameHeight + 50) {
      removeFromParent();
    }
  }
  
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is BrickWall) {
      other.takeDamage(damage);
      _onHit();
    } else if (other is SteelWall) {
      _onHit();
    } else if (other is Base) {
      other.destroy();
      _onHit();
    } else if (other is Tank && other != owner) {
      if (_canDamageTarget(other)) {
        other.takeDamage(damage);
        _onHit();
      }
    } else if (other is ScreenHitbox) {
      removeFromParent();
    }
  }
  
  bool _canDamageTarget(Tank target) {
    if (owner is PlayerTank && target is EnemyTank) {
      return true;
    }
    if (owner is EnemyTank && target is PlayerTank) {
      return true;
    }
    return false;
  }
  
  void _onHit() {
    removeFromParent();
  }
  
  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}