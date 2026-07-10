import 'dart:ui';

class GameConstants {
  static const int gridRows = 26;
  static const int gridCols = 26;
  static const double cellSize = 16.0;
  static const double gameWidth = gridCols * cellSize;
  static const double gameHeight = gridRows * cellSize;
  
  static const double infoPanelWidth = 200.0;
  static const double minWindowWidth = 800.0;
  static const double minWindowHeight = 600.0;
  
  static const int totalLevels = 35;
  static const int enemiesPerLevel = 20;
  static const int initialLives = 3;
  
  static const double playerSpeed = 120.0;
  static const double enemySpeed = 80.0;
  static const double bulletSpeed = 300.0;
  
  static const double playerFireRate = 0.3;
  static const double enemyFireRate = 1.0;
  
  static const Color backgroundColor = Color(0xFF000000);
  static const Color brickColor = Color(0xFF8B4513);
  static const Color steelColor = Color(0xFFC0C0C0);
  static const Color waterColor = Color(0xFF0000FF);
  static const Color forestColor = Color(0xFF008000);
  static const Color iceColor = Color(0xFFADD8E6);
  static const Color playerColor = Color(0xFFFFFF00);
  static const Color enemyColor = Color(0xFFFF0000);
  static const Color bulletColor = Color(0xFFFFFFFF);
  static const Color baseColor = Color(0xFFFFA500);
}

enum Direction { up, down, left, right }

enum TankType { player, normal, fast, armor, heavy }

enum TerrainType { empty, brick, steel, water, forest, ice }

enum PowerUpType { star, bomb, clock, shovel, tank, helmet }