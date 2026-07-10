import 'dart:math';
import 'package:flame/components.dart';
import '../../data/constants.dart';
import '../../utils/sprite_generator.dart';
import 'tank.dart';
import 'player_tank.dart';

enum EnemyType { normal, fast, armor, heavy }

class EnemyTank extends Tank {
  final EnemyType type;
  double aiTimer = 0;
  double aiInterval = 0.5;
  final Random random = Random();
  double moveTimer = 0;
  double _wallHitCooldown = 0;

  EnemyTank({
    required super.position,
    this.type = EnemyType.normal,
  }) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _configureByType();
    await _loadSprite();
    // 一生成就给点初始动感，否则要等下个 AI tick 才动
    moveTimer = 1.0;
  }

  void _configureByType() {
    switch (type) {
      case EnemyType.normal:
        speed = GameConstants.enemySpeed;
        health = 100;
        maxHealth = 100;
        fireRate = GameConstants.enemyFireRate;
        break;
      case EnemyType.fast:
        speed = GameConstants.enemySpeed * 1.5;
        health = 80;
        maxHealth = 80;
        fireRate = GameConstants.enemyFireRate * 0.8;
        break;
      case EnemyType.armor:
        speed = GameConstants.enemySpeed * 0.8;
        health = 200;
        maxHealth = 200;
        fireRate = GameConstants.enemyFireRate;
        break;
      case EnemyType.heavy:
        speed = GameConstants.enemySpeed * 0.6;
        health = 300;
        maxHealth = 300;
        fireRate = GameConstants.enemyFireRate * 0.7;
        break;
    }
  }

  Future<void> _loadSprite() async {
    final img = await SpriteGenerator.getEnemyTank(direction, type.index);
    sprite = Sprite(img);
  }

  @override
  void move(Direction newDirection) {
    super.move(newDirection);
    _loadSprite();
  }

  @override
  void update(double dt) {
    super.update(dt);

    aiTimer -= dt;
    moveTimer -= dt;
    if (_wallHitCooldown > 0) _wallHitCooldown -= dt;

    if (aiTimer <= 0) {
      aiTimer = aiInterval;
      _updateAI();
    }

    if (moveTimer > 0) {
      final delta = getMovementDelta(dt);
      position += delta;
      _clampPosition();
    }
  }

  @override
  void onHitWall() {
    // 撞墙后立刻随机换方向，避免一直贴着墙原地抖动；带冷却防每帧触发。
    if (_wallHitCooldown > 0) return;
    _wallHitCooldown = 0.3;
    _pickRandomDirection();
    moveTimer = 0.8 + random.nextDouble() * 1.2;
  }

  void _updateAI() {
    final player = _findPlayer();

    if (player != null && _shouldChasePlayer(player)) {
      _chasePlayer(player);
      moveTimer = 1.2 + random.nextDouble(); // 追击走久一点
    } else if (random.nextDouble() < 0.6) {
      _pickRandomDirection();
      moveTimer = 0.8 + random.nextDouble() * 1.6;
    } else {
      // 保持当前方向继续走
      if (moveTimer <= 0) moveTimer = 0.6 + random.nextDouble();
    }

    if (random.nextDouble() < 0.4) {
      fire();
    }
  }
  
  PlayerTank? _findPlayer() {
    PlayerTank? player;
    parent?.children.whereType<PlayerTank>().forEach((p) {
      player = p;
    });
    return player;
  }
  
  bool _shouldChasePlayer(PlayerTank player) {
    final distance = position.distanceTo(player.position);
    return distance < 200;
  }
  
  void _chasePlayer(PlayerTank player) {
    final diff = player.position - position;

    if (diff.x.abs() > diff.y.abs()) {
      move(diff.x > 0 ? Direction.right : Direction.left);
    } else {
      move(diff.y > 0 ? Direction.down : Direction.up);
    }
  }

  void _pickRandomDirection() {
    final directions = Direction.values;
    move(directions[random.nextInt(directions.length)]);
  }
  
  void _clampPosition() {
    final halfW = size.x / 2;
    final halfH = size.y / 2;
    position.x = position.x.clamp(halfW, GameConstants.gameWidth - halfW);
    position.y = position.y.clamp(halfH, GameConstants.gameHeight - halfH);
  }
  
  @override
  void destroy() {
    super.destroy();
    game.addScore(_getScore());
  }
  
  int _getScore() {
    switch (type) {
      case EnemyType.normal:
        return 100;
      case EnemyType.fast:
        return 200;
      case EnemyType.armor:
        return 300;
      case EnemyType.heavy:
        return 400;
    }
  }
  
  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}