import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:jogo_2d_udemy/components/circle/collidable.dart';

class CircleGame extends FlameGame with HasCollisionDetection, TapDetector {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(ScreenHitbox());
  }

  @override
  void onTapDown(TapDownInfo info) {
    add(Collidable(info.eventPosition.global));
  }
}
