import 'constants.dart';
import 'package:flame/components.dart';
import '../components/tanks/enemy_tank.dart';

class Levels {
  static List<List<TerrainType>> getMapData(int level) {
    switch (level) {
      case 1:
        return _level1;
      case 2:
        return _level2;
      case 3:
        return _level3;
      default:
        return _generateRandomLevel(level);
    }
  }
  
  static List<EnemySpawn> getEnemySpawns(int level) {
    return [
      EnemySpawn(
        position: Vector2(GameConstants.cellSize * 2, GameConstants.cellSize),
        type: EnemyType.normal,
      ),
      EnemySpawn(
        position: Vector2(GameConstants.gameWidth / 2, GameConstants.cellSize),
        type: _getEnemyType(level),
      ),
      EnemySpawn(
        position: Vector2(GameConstants.gameWidth - GameConstants.cellSize * 2, GameConstants.cellSize),
        type: _getEnemyType(level),
      ),
    ];
  }
  
  static EnemyType _getEnemyType(int level) {
    if (level <= 5) return EnemyType.normal;
    if (level <= 10) return level % 2 == 0 ? EnemyType.fast : EnemyType.normal;
    if (level <= 20) return EnemyType.values[level % 4];
    return EnemyType.values[level % 4];
  }
  
  static final List<List<TerrainType>> _level1 = [
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, S, S, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, S, S, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B],
    [B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B],
    [E, E, E, E, E, E, E, E, E, E, E, E, W, W, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, W, W, E, E, E, E, E, E, E, E, E, E, E, E],
    [B, B, E, E, B, B, E, E, B, B, E, E, E, E, E, E, B, B, E, E, B, B, E, E, B, B],
    [B, B, E, E, B, B, E, E, B, B, E, E, E, E, E, E, B, B, E, E, B, B, E, E, B, B],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
  ];
  
  static final List<List<TerrainType>> _level2 = [
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, B, B, E, E, B, B, E, E, S, S, E, E, S, S, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, S, S, E, E, S, S, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, W, W, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, W, W, E, E, E, E, E, E, E, E, E, E, E, E],
    [S, S, E, E, B, B, E, E, S, S, E, E, E, E, E, E, S, S, E, E, B, B, E, E, S, S],
    [S, S, E, E, B, B, E, E, S, S, E, E, E, E, E, E, S, S, E, E, B, B, E, E, S, S],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [B, B, E, E, B, B, E, E, B, B, E, E, E, E, E, E, B, B, E, E, B, B, E, E, B, B],
    [B, B, E, E, B, B, E, E, B, B, E, E, E, E, E, E, B, B, E, E, B, B, E, E, B, B],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
  ];
  
  static final List<List<TerrainType>> _level3 = [
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, S, S, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, S, S, E, E],
    [E, E, S, S, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, S, S, E, E],
    [E, E, S, S, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, S, S, E, E],
    [E, E, S, S, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, S, S, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, I, I, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, I, I, E, E, E, E, E, E, E, E, E, E, E, E],
    [B, B, E, E, S, S, E, E, B, B, E, E, E, E, E, E, B, B, E, E, S, S, E, E, B, B],
    [B, B, E, E, S, S, E, E, B, B, E, E, E, E, E, E, B, B, E, E, S, S, E, E, B, B],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, B, B, E, E, W, W, E, E, B, B, E, E, B, B, E, E, W, W, E, E, B, B, E, E],
    [E, E, B, B, E, E, W, W, E, E, B, B, E, E, B, B, E, E, W, W, E, E, B, B, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E, B, B, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, E, E, E],
    [E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E],
  ];
  
  static List<List<TerrainType>> _generateRandomLevel(int level) {
    final random = level * 12345;
    final map = List.generate(
      GameConstants.gridRows,
      (row) => List.generate(
        GameConstants.gridCols,
        (col) => TerrainType.empty,
      ),
    );
    
    for (int i = 0; i < 50 + level * 2; i++) {
      final r = (random + i * 7) % 24 + 1;
      final c = (random + i * 11) % 24 + 1;
      
      if (r > 0 && r < 25 && c > 0 && c < 25) {
        final typeIndex = (random + i) % 5;
        map[r][c] = TerrainType.values[typeIndex + 1];
      }
    }
    
    return map;
  }
}

const E = TerrainType.empty;
const B = TerrainType.brick;
const S = TerrainType.steel;
const W = TerrainType.water;
const F = TerrainType.forest;
const I = TerrainType.ice;

class EnemySpawn {
  final Vector2 position;
  final EnemyType type;
  
  EnemySpawn({required this.position, required this.type});
}