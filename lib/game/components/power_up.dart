import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';
import '../data/constants.dart';
import 'tanks/player_tank.dart';
import 'tanks/enemy_tank.dart';
import '../tank_war_game.dart';

class PowerUp extends PositionComponent with CollisionCallbacks, HasGameReference<TankWarGame> {
  final PowerUpType type;
  double lifetime = 15.0;
  
  PowerUp({
    required Vector2 position,
    required this.type,
  }) : super(
    position: position,
    size: Vector2(GameConstants.cellSize * 2, GameConstants.cellSize * 2),
    anchor: Anchor.center,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _addVisual();
    add(RectangleHitbox());
  }
  
  void _addVisual() {
    final colors = {
      PowerUpType.star: BasicPalette.yellow.paint(),
      PowerUpType.bomb: BasicPalette.red.paint(),
      PowerUpType.clock: BasicPalette.cyan.paint(),
      PowerUpType.shovel: BasicPalette.brown.paint(),
      PowerUpType.tank: BasicPalette.green.paint(),
      PowerUpType.helmet: BasicPalette.gray.paint(),
    };
    
    final paint = colors[type]!;
    
    add(RectangleComponent(
      size: size,
      paint: paint,
    ));
    
    add(RectangleComponent(
      size: Vector2(size.x - 4, size.y - 4),
      paint: Paint()..color = const Color(0xFF111111),
    ));
    
    add(RectangleComponent(
      size: Vector2(size.x - 8, size.y - 8),
      paint: paint,
    ));
    
    final symbolColors = {
      PowerUpType.star: '*',
      PowerUpType.bomb: 'B',
      PowerUpType.clock: 'C',
      PowerUpType.shovel: 'S',
      PowerUpType.tank: 'T',
      PowerUpType.helmet: 'H',
    };
    
    add(TextComponent(
      text: symbolColors[type]!,
      size: Vector2(size.x - 8, size.y - 8),
      anchor: Anchor.center,
    ));
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    lifetime -= dt;
    if (lifetime <= 0) {
      removeFromParent();
    }
  }
  
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is PlayerTank) {
      applyEffect(other);
      removeFromParent();
    }
  }
  
  void applyEffect(PlayerTank player) {
    switch (type) {
      case PowerUpType.star:
        player.upgrade();
        break;
      case PowerUpType.bomb:
        _destroyAllEnemies();
        break;
      case PowerUpType.clock:
        _freezeEnemies();
        break;
      case PowerUpType.shovel:
        _protectBase();
        break;
      case PowerUpType.tank:
        player.lives++;
        break;
      case PowerUpType.helmet:
        player.activateInvincibility(10.0);
        break;
    }
  }
  
  void _destroyAllEnemies() {
    parent?.children.whereType<EnemyTank>().forEach((enemy) {
      enemy.destroy();
    });
  }
  
  void _freezeEnemies() {
    parent?.children.whereType<EnemyTank>().forEach((enemy) {
      enemy.speed = 0;
      Future.delayed(const Duration(seconds: 5), () {
        enemy.speed = GameConstants.enemySpeed;
      });
    });
  }
  
  void _protectBase() {
  }
  
  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}