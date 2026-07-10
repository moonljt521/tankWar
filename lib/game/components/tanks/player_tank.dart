import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../data/constants.dart';
import '../../utils/sprite_generator.dart';
import 'tank.dart';

class PlayerTank extends Tank {
  int lives = GameConstants.initialLives;
  bool isInvincible = false;
  double invincibleTimer = 0;
  int level = 1;
  double _blinkTimer = 0;
  bool _blinkVisible = true;
  
  PlayerTank({required Vector2 position}) 
      : super(position: position, size: Vector2(32, 32));
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    speed = GameConstants.playerSpeed;
    health = 100;
    maxHealth = 100;
    fireRate = GameConstants.playerFireRate;
    
    final img = await SpriteGenerator.getPlayerTank(Direction.up);
    sprite = Sprite(img);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (isInvincible) {
      invincibleTimer -= dt;
      _blinkTimer -= dt;
      if (_blinkTimer <= 0) {
        _blinkTimer = 0.15;
        _blinkVisible = !_blinkVisible;
        opacity = _blinkVisible ? 1.0 : 0.3;
      }
      if (invincibleTimer <= 0) {
        isInvincible = false;
        opacity = 1.0;
      }
    }
  }

  @override
  void move(Direction newDirection) {
    super.move(newDirection);
    _updateSprite();
  }

  void _updateSprite() async {
    final img = await SpriteGenerator.getPlayerTank(direction);
    sprite = Sprite(img);
  }
  
  void handleInput(Set<LogicalKeyboardKey> keysPressed) {
    bool isMoving = false;
    
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) || 
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      move(Direction.up);
      isMoving = true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown) || 
               keysPressed.contains(LogicalKeyboardKey.keyS)) {
      move(Direction.down);
      isMoving = true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) || 
               keysPressed.contains(LogicalKeyboardKey.keyA)) {
      move(Direction.left);
      isMoving = true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) || 
               keysPressed.contains(LogicalKeyboardKey.keyD)) {
      move(Direction.right);
      isMoving = true;
    }
    
    if (isMoving) {
      final delta = getMovementDelta(1/60);
      position += delta;
      _clampPosition();
    }
    
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      fire();
    }
  }
  
  void _clampPosition() {
    final halfW = size.x / 2;
    final halfH = size.y / 2;
    position.x = position.x.clamp(halfW, GameConstants.gameWidth - halfW);
    position.y = position.y.clamp(halfH, GameConstants.gameHeight - halfH);
  }
  
  @override
  void takeDamage(double damage) {
    if (isInvincible) return;
    super.takeDamage(damage);
  }
  
  @override
  void destroy() {
    lives--;
    if (lives > 0) {
      respawn();
    } else {
      super.destroy();
      game.gameOver();
    }
  }
  
  void respawn() {
    health = maxHealth;
    isInvincible = true;
    invincibleTimer = 3.0;
    position = Vector2(
      GameConstants.gameWidth / 2 - GameConstants.cellSize * 2,
      GameConstants.gameHeight - GameConstants.cellSize * 2,
    );
  }
  
  void upgrade() {
    if (level < 3) {
      level++;
      switch (level) {
        case 2:
          speed = GameConstants.playerSpeed * 1.2;
          fireRate = GameConstants.playerFireRate * 0.8;
          break;
        case 3:
          speed = GameConstants.playerSpeed * 1.5;
          fireRate = GameConstants.playerFireRate * 0.6;
          break;
      }
    }
  }
  
  void activateInvincibility(double duration) {
    isInvincible = true;
    invincibleTimer = duration;
  }
  
  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }
}