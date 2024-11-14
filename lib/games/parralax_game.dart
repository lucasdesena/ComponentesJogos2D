import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class ParralaxGame extends FlameGame {
  /// Mapping of images and velocity deltas
  final _layersMeta = {
    'parralax/bg.png': 1.0,
    'parralax/mountain-far.png': 1.5,
    'parralax/mountains.png': 2.3,
    'parralax/trees.png': 5.0,
    'parralax/foreground-trees.png': 24.0,
  };

  @override
  Future<void> onLoad() async {
    /// for each map entry for the layers, load the layer with the
    /// corresponding image (the key) and the velocity multiplier (value)
    final layers = _layersMeta.entries.map(
      (e) => loadParallaxLayer(
        ParallaxImageData(e.key),
        velocityMultiplier: Vector2(e.value, 1.0),
      ),
    );

    /// load the collection of layers into the parallax
    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(20, 0),
      ),
    );
    add(parallax);
  }
}