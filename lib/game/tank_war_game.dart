import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/constants.dart';
import 'systems/level_manager.dart';
import 'systems/audio_manager.dart';
import 'utils/sprite_generator.dart';
import 'components/tanks/player_tank.dart';
import 'components/tanks/enemy_tank.dart' as enemy;
import 'components/base.dart';

class TankWarGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late final LevelManager levelManager;
  late final AudioManager audioManager;
  
  int currentLevel = 1;
  int lives = GameConstants.initialLives;
  int score = 0;
  int highScore = 0;
  
  bool isPaused = false;
  bool isGameOver = false;
  
  final Set<LogicalKeyboardKey> _pressedKeys = {};
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 固定逻辑分辨率：游戏画面始终在 416x416 内布局，
    // 由 FixedResolutionViewport 自适应缩放到窗口大小（保持比例并居中）。
    // 相机对准世界中心，确保完整显示 0..416 的整张地图。
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(GameConstants.gameWidth, GameConstants.gameHeight),
    );
    camera.viewfinder.position = Vector2(
      GameConstants.gameWidth / 2,
      GameConstants.gameHeight / 2,
    );
    camera.viewfinder.anchor = Anchor.center;

    levelManager = LevelManager();
    audioManager = AudioManager();
    
    await _loadSaveData();
    
    router = RouterComponent(
      routes: {
        'loading': Route(LoadingScreen.new),
        'title': Route(TitleScreen.new),
        'stage': Route(StageScreen.new),
        'game': WorldRoute(GameWorld.new),
        'pause': PauseRoute(),
        'gameover': GameOverRoute(),
      },
      initialRoute: 'loading',
    );
    
    add(router);
  }
  
  Future<void> _loadSaveData() async {
    final prefs = await SharedPreferences.getInstance();
    currentLevel = prefs.getInt('currentLevel') ?? 1;
    highScore = prefs.getInt('highScore') ?? 0;
    lives = prefs.getInt('lives') ?? GameConstants.initialLives;
  }
  
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentLevel', currentLevel);
    await prefs.setInt('highScore', highScore);
    await prefs.setInt('lives', lives);
  }
  
  void startGame() {
    currentLevel = 1;
    lives = GameConstants.initialLives;
    score = 0;
    isGameOver = false;
    router.pushNamed('stage');
  }
  
  void startLevel() {
    router.pushReplacementNamed('game');
  }
  
  void nextLevel() {
    currentLevel++;
    if (currentLevel > GameConstants.totalLevels) {
      currentLevel = 1;
    }
    _saveData();
    router.pushNamed('stage');
  }
  
  void pauseGame() {
    isPaused = true;
    router.pushNamed('pause');
  }
  
  void resumeGame() {
    isPaused = false;
    router.pop();
  }
  
  void gameOver() {
    isGameOver = true;
    if (score > highScore) {
      highScore = score;
    }
    _saveData();
    router.pushNamed('gameover');
  }
  
  void addScore(int points) {
    score += points;
    if (score > highScore) {
      highScore = score;
    }
  }
  
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        if (router.currentRoute.name == 'game') {
          pauseGame();
        } else if (router.currentRoute.name == 'pause') {
          resumeGame();
        }
      }
      if (event.logicalKey == LogicalKeyboardKey.keyP) {
        if (router.currentRoute.name == 'game') {
          pauseGame();
        }
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (router.currentRoute.name == 'title') {
          startGame();
        } else if (router.currentRoute.name == 'gameover') {
          startGame();
        }
      }
    }
    
    _pressedKeys.clear();
    _pressedKeys.addAll(keysPressed);
    
    return KeyEventResult.handled;
  }
  
  Set<LogicalKeyboardKey> get pressedKeys => _pressedKeys;
  
  @override
  void onRemove() {
    _saveData();
    super.onRemove();
  }
}

class LoadingScreen extends Component with HasGameReference<TankWarGame> {
  double _timer = 0;
  
  @override
  Future<void> onLoad() async {
    add(
      RectangleComponent(
        size: game.size,
        paint: Paint()..color = Colors.black,
      ),
    );
    
    add(
      TextComponent(
        text: 'LOADING...',
        position: game.size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= 0.5) {
      SpriteGenerator.generateAll().then((_) {
        game.router.pushReplacementNamed('title');
      });
    }
  }
}

class TitleScreen extends Component with HasGameReference<TankWarGame> {
  double _blinkTimer = 0;
  bool _showText = true;
  late TextComponent _pressText;
  
  @override
  Future<void> onLoad() async {
    add(
      RectangleComponent(
        size: game.size,
        paint: Paint()..color = Colors.black,
      ),
    );
    
    add(
      TextComponent(
        text: 'TANK',
        position: Vector2(game.size.x / 2, game.size.y * 0.28),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF4444),
            shadows: [
              const Shadow(offset: Offset(3, 3), color: Color(0xFF880000)),
            ],
          ),
        ),
      ),
    );
    
    add(
      TextComponent(
        text: 'WAR',
        position: Vector2(game.size.x / 2, game.size.y * 0.38),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFAA00),
            shadows: [
              const Shadow(offset: Offset(3, 3), color: Color(0xFF884400)),
            ],
          ),
        ),
      ),
    );
    
    _pressText = TextComponent(
      text: 'Press ENTER to Start',
      position: Vector2(game.size.x / 2, game.size.y * 0.55),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 22,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
    add(_pressText);
    
    add(
      TextComponent(
        text: 'High Score: ${game.highScore}',
        position: Vector2(game.size.x / 2, game.size.y * 0.65),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFFFFFF00),
          ),
        ),
      ),
    );
    
    add(
      TextComponent(
        text: '1 PLAYER',
        position: Vector2(game.size.x / 2, game.size.y * 0.78),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFFAAAAAA),
          ),
        ),
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _blinkTimer += dt;
    if (_blinkTimer >= 0.5) {
      _blinkTimer = 0;
      _showText = !_showText;
      if (_showText) {
        _pressText.text = 'Press ENTER to Start';
      } else {
        _pressText.text = '';
      }
    }
  }
}

class StageScreen extends Component with HasGameReference<TankWarGame> {
  double _timer = 0;
  
  @override
  Future<void> onLoad() async {
    add(
      RectangleComponent(
        size: game.size,
        paint: Paint()..color = Colors.black,
      ),
    );
    
    add(
      TextComponent(
        text: 'STAGE  ${game.currentLevel}',
        position: game.size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= 2.0) {
      game.startLevel();
    }
  }
}

class GameWorld extends World with HasCollisionDetection, HasGameReference<TankWarGame> {
  late PlayerTank player;
  late Base base;
  List<enemy.EnemyTank> enemies = [];
  int enemiesRemaining = GameConstants.enemiesPerLevel;
  double spawnTimer = 0;
  double spawnInterval = 3.0;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    add(ScreenHitbox());
    
    game.levelManager.loadLevel(game.currentLevel);
    game.levelManager.buildLevel(this);
    
    player = game.levelManager.player!;
    base = game.levelManager.base!;
    
    _spawnInitialEnemies();
  }
  
  void _spawnInitialEnemies() {
    for (int i = 0; i < 3; i++) {
      _spawnEnemy();
    }
  }
  
  void _spawnEnemy() {
    if (enemiesRemaining <= 0) return;
    if (enemies.length >= 4) return;
    
    final spawnPositions = [
      Vector2(GameConstants.cellSize * 2, GameConstants.cellSize),
      Vector2(GameConstants.gameWidth / 2, GameConstants.cellSize),
      Vector2(GameConstants.gameWidth - GameConstants.cellSize * 2, GameConstants.cellSize),
    ];
    
    final spawnIndex = enemies.length % 3;
    final position = spawnPositions[spawnIndex];
    
    final enemyTank = enemy.EnemyTank(position: position);
    add(enemyTank);
    enemies.add(enemyTank);
    enemiesRemaining--;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (game.isPaused) return;
    
    player.handleInput(game.pressedKeys);
    
    spawnTimer -= dt;
    if (spawnTimer <= 0) {
      spawnTimer = spawnInterval;
      _spawnEnemy();
    }
    
    enemies.removeWhere((e) => e.isDestroyed);
    
    if (enemiesRemaining <= 0 && enemies.isEmpty) {
      game.nextLevel();
    }
  }
}

class PauseRoute extends Route {
  PauseRoute() : super(PausePage.new, transparent: true);
}

class PausePage extends Component with HasGameReference<TankWarGame> {
  @override
  Future<void> onLoad() async {
    add(
      RectangleComponent(
        size: game.size,
        paint: Paint()..color = const Color(0xAA000000),
      ),
    );
    
    add(
      RectangleComponent(
        size: Vector2(200, 120),
        position: game.size / 2,
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFF222222),
      ),
    );
    
    add(
      RectangleComponent(
        size: Vector2(196, 116),
        position: game.size / 2,
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFF333333),
      ),
    );
    
    add(
      TextComponent(
        text: 'PAUSE',
        position: Vector2(game.size.x / 2, game.size.y / 2 - 20),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
    
    add(
      TextComponent(
        text: 'P / ESC to resume',
        position: Vector2(game.size.x / 2, game.size.y / 2 + 20),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFAAAAAA),
          ),
        ),
      ),
    );
  }
  
  @override
  bool containsLocalPoint(Vector2 point) => true;
}

class GameOverRoute extends Route {
  GameOverRoute() : super(GameOverPage.new, transparent: true);
}

class GameOverPage extends Component with HasGameReference<TankWarGame> {
  double _timer = 0;
  
  @override
  Future<void> onLoad() async {
    add(
      RectangleComponent(
        size: game.size,
        paint: Paint()..color = const Color(0xBB000000),
      ),
    );
    
    add(
      TextComponent(
        text: 'GAME',
        position: Vector2(game.size.x / 2, game.size.y * 0.3),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF4444),
            shadows: [
              const Shadow(offset: Offset(3, 3), color: Color(0xFF880000)),
            ],
          ),
        ),
      ),
    );
    
    add(
      TextComponent(
        text: 'OVER',
        position: Vector2(game.size.x / 2, game.size.y * 0.3 + 60),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF4444),
            shadows: [
              const Shadow(offset: Offset(3, 3), color: Color(0xFF880000)),
            ],
          ),
        ),
      ),
    );
    
    add(
      TextComponent(
        text: 'Score: ${game.score}',
        position: Vector2(game.size.x / 2, game.size.y * 0.5),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
    
    add(
      TextComponent(
        text: 'High Score: ${game.highScore}',
        position: Vector2(game.size.x / 2, game.size.y * 0.57),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFFFFFF00),
          ),
        ),
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
  }
  
  @override
  bool containsLocalPoint(Vector2 point) => true;
}