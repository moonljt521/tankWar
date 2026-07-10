import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../data/constants.dart';
import '../bullet.dart';
import '../terrain/brick_wall.dart';
import '../terrain/steel_wall.dart';
import '../terrain/water.dart';
import '../base.dart';
import '../../tank_war_game.dart';

abstract class Tank extends SpriteComponent 
    with CollisionCallbacks, HasGameReference<TankWarGame> {
  
  Direction direction = Direction.up;
  double speed = GameConstants.playerSpeed;
  double health = 100;
  double maxHealth = 100;
  double fireRate = GameConstants.playerFireRate;
  double _fireCooldown = 0;
  bool isDestroyed = false;
  
  Tank({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    if (_fireCooldown > 0) {
      _fireCooldown -= dt;
    }
  }
  
  void move(Direction newDirection) {
    direction = newDirection;
    // 朝向已通过 sprite 的预渲染表达，这里不再额外旋转 component，
    // 否则会与 sprite 内的方向叠加产生双重旋转。
  }
  
  Vector2 getMovementDelta(double dt) {
    final delta = Vector2.zero();
    switch (direction) {
      case Direction.up:
        delta.y = -speed * dt;
        break;
      case Direction.down:
        delta.y = speed * dt;
        break;
      case Direction.left:
        delta.x = -speed * dt;
        break;
      case Direction.right:
        delta.x = speed * dt;
        break;
    }
    return delta;
  }
  
  bool canFire() {
    return _fireCooldown <= 0;
  }
  
  void fire() {
    if (!canFire()) return;
    
    _fireCooldown = fireRate;
    
    final bulletPos = _getBulletSpawnPosition();
    final bullet = Bullet(
      position: bulletPos,
      direction: direction,
      owner: this,
    );
    
    parent?.add(bullet);
  }
  
  Vector2 _getBulletSpawnPosition() {
    final offset = Vector2.zero();
    switch (direction) {
      case Direction.up:
        offset.y = -size.y / 2 - 4;
        break;
      case Direction.down:
        offset.y = size.y / 2 + 4;
        break;
      case Direction.left:
        offset.x = -size.x / 2 - 4;
        break;
      case Direction.right:
        offset.x = size.x / 2 + 4;
        break;
    }
    return position + offset;
  }
  
  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      destroy();
    }
  }
  
  void destroy() {
    if (isDestroyed) return;
    isDestroyed = true;
    removeFromParent();
  }
  
  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);

    if (other is BrickWall || other is SteelWall || other is Water || other is Base) {
      _handleWallCollision(other);
      onHitWall();
    }
  }

  void onHitWall() {}

  void _handleWallCollision(PositionComponent wall) {
    final tankRect = Rect.fromCenter(
      center: Offset(position.x, position.y),
      width: size.x,
      height: size.y,
    );

    final wallRect = Rect.fromLTWH(
      wall.position.x - wall.size.x / 2,
      wall.position.y - wall.size.y / 2,
      wall.size.x,
      wall.size.y,
    );

    if (!tankRect.overlaps(wallRect)) return;

    switch (direction) {
      case Direction.up:
        position.y = wallRect.bottom + size.y / 2;
        break;
      case Direction.down:
        position.y = wallRect.top - size.y / 2;
        break;
      case Direction.left:
        position.x = wallRect.right + size.x / 2;
        break;
      case Direction.right:
        position.x = wallRect.left - size.x / 2;
        break;
    }
  }
}