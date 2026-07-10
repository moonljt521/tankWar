import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import '../../data/constants.dart';

class BasicExplosion extends PositionComponent {
  double _timer = 0;
  final double duration = 0.4;
  final List<RectangleComponent> _particles = [];
  
  BasicExplosion({required Vector2 position}) 
      : super(
          position: position,
          size: Vector2(GameConstants.cellSize * 2, GameConstants.cellSize * 2),
          anchor: Anchor.center,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final colors = [
      BasicPalette.red.paint(),
      BasicPalette.orange.paint(),
      BasicPalette.yellow.paint(),
      BasicPalette.white.paint(),
    ];
    
    for (int i = 0; i < 8; i++) {
      final particle = RectangleComponent(
        size: Vector2(6, 6),
        position: Vector2(
          size.x / 2 + (i % 3 - 1) * 8,
          size.y / 2 + (i ~/ 3 - 1) * 8,
        ),
        paint: colors[i % colors.length],
        anchor: Anchor.center,
      );
      add(particle);
      _particles.add(particle);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    
    final progress = _timer / duration;
    for (int i = 0; i < _particles.length; i++) {
      final angle = i * 0.785;
      final speed = 50 + i * 10;
      _particles[i].position.x += cos(angle) * speed * dt;
      _particles[i].position.y += sin(angle) * speed * dt;
      _particles[i].opacity = 1 - progress;
    }
    
    if (_timer >= duration) {
      removeFromParent();
    }
  }
}