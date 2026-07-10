import 'package:flame/components.dart';
import '../data/constants.dart';
import '../data/levels.dart';
import '../components/terrain/brick_wall.dart';
import '../components/terrain/steel_wall.dart';
import '../components/terrain/water.dart';
import '../components/terrain/forest.dart';
import '../components/terrain/ice.dart';
import '../components/base.dart';
import '../components/tanks/player_tank.dart';
import '../components/tanks/enemy_tank.dart' as enemy;
import '../components/power_up.dart';

class LevelManager extends Component {
  int currentLevel = 1;
  List<List<TerrainType>> mapData = [];
  PlayerTank? player;
  Base? base;
  
  void loadLevel(int level) {
    currentLevel = level;
    mapData = Levels.getMapData(level);
  }
  
  void buildLevel(World world) {
    _clearLevel(world);
    _buildTerrain(world);
    _buildBase(world);
    _buildPlayer(world);
  }
  
  void _clearLevel(World world) {
    final componentsToRemove = world.children.where((component) {
      return component is BrickWall ||
             component is SteelWall ||
             component is Water ||
             component is Forest ||
             component is Ice ||
             component is Base ||
             component is PlayerTank ||
             component is enemy.EnemyTank;
    }).toList();
    
    for (final component in componentsToRemove) {
      component.removeFromParent();
    }
  }
  
  void _buildTerrain(World world) {
    for (int row = 0; row < GameConstants.gridRows; row++) {
      for (int col = 0; col < GameConstants.gridCols; col++) {
        if (row < mapData.length && col < mapData[row].length) {
          final terrain = mapData[row][col];
          final position = Vector2(
            col * GameConstants.cellSize + GameConstants.cellSize / 2,
            row * GameConstants.cellSize + GameConstants.cellSize / 2,
          );
          
          switch (terrain) {
            case TerrainType.brick:
              world.add(BrickWall(position: position));
              break;
            case TerrainType.steel:
              world.add(SteelWall(position: position));
              break;
            case TerrainType.water:
              world.add(Water(position: position));
              break;
            case TerrainType.forest:
              world.add(Forest(position: position));
              break;
            case TerrainType.ice:
              world.add(Ice(position: position));
              break;
            case TerrainType.empty:
              break;
          }
        }
      }
    }
  }
  
  void _buildBase(World world) {
    final basePos = Vector2(
      GameConstants.gameWidth / 2,
      GameConstants.gameHeight - GameConstants.cellSize,
    );
    base = Base(position: basePos);
    world.add(base!);
  }
  
  void _buildPlayer(World world) {
    final playerPos = Vector2(
      GameConstants.gameWidth / 2 - GameConstants.cellSize * 2,
      GameConstants.gameHeight - GameConstants.cellSize * 2,
    );
    player = PlayerTank(position: playerPos);
    world.add(player!);
  }
  
  void spawnPowerUp(World world) {
    final random = DateTime.now().millisecondsSinceEpoch;
    final types = PowerUpType.values;
    final type = types[random % types.length];
    
    final position = Vector2(
      (random % 200 + 50).toDouble(),
      (random % 200 + 50).toDouble(),
    );
    
    world.add(PowerUp(position: position, type: type));
  }
}