import 'package:flame/components.dart';
import '../../data/constants.dart';

class BasicExplosion extends PositionComponent {
  double _timer = 0;
  final double duration = 0.3;
  
  BasicExplosion({required Vector2 position}) 
      : super(
          position: position,
          size: Vector2(GameConstants.cellSize * 2, GameConstants.cellSize * 2),
          anchor: Anchor.center,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= duration) {
      removeFromParent();
    }
  }
}