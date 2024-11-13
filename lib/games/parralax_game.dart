import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class ParralaxGame extends FlameGame {
  final _imageNames = [
    ParallaxImageData('parralax/bg.png'),
    ParallaxImageData('parralax/mountain-far.png'),
    ParallaxImageData('parralax/mountains.png'),
    ParallaxImageData('parralax/trees.png'),
    ParallaxImageData('parralax/foreground-trees.png'),
  ];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final parallax = await loadParallaxComponent(
      _imageNames,
      baseVelocity: Vector2(20.0, 0.0),
      velocityMultiplierDelta: Vector2(1.8, 0.0),
    );
    add(parallax);
  }
}