import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import '../../data/constants.dart';

class SimpleExplosion extends PositionComponent {
  double _timer = 0;
  final double duration = 0.3;
  final List<CircleComponent> _circles = [];
  
  SimpleExplosion({required Vector2 position}) 
      : super(
          position: position,
          size: Vector2(GameConstants.cellSize * 3, GameConstants.cellSize * 3),
          anchor: Anchor.center,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    for (int i = 0; i < 5; i++) {
      final circle = CircleComponent(
        radius: 4 + i * 3,
        position: Vector2(
          size.x / 2 - (2 - i) * 5,
          size.y / 2 - (2 - i) * 5,
        ),
        paint: BasicPalette.orange.paint(),
      );
      add(circle);
      _circles.add(circle);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    
    final progress = _timer / duration;
    for (int i = 0; i < _circles.length; i++) {
      _circles[i].scale = Vector2.all(1 + progress * 2);
      _circles[i].opacity = 1 - progress;
    }
    
    if (_timer >= duration) {
      removeFromParent();
    }
  }
}