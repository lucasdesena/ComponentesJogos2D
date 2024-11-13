import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:jogo_2d_udemy/components/particle/particle_one.dart';

class ParticleGame extends FlameGame with PanDetector, TapDetector {
  @override
  Future<void> onLoad() async {
    await images.load('particle/boom.png');
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    add(
      ParticleOne.createParticleEngine(
        position: info.eventPosition.global,
      ),
      // ParticleTwo.createParticleEngine(
      //   position: info.eventPosition.global,
      // ),
      // ParticleThree.createParticleEngine(
      //   position: info.eventPosition.global,
      // ),
    );
  }

  @override
  void onTapUp(TapUpInfo info) {
    // get the tap position
    Vector2 position = info.eventPosition.global;
    // adjust the tap position to the prite position byt subtracting the size
    // of the rendered sprite
    position.sub(Vector2(0, 0));
    // create the ParticleComponent
    ParticleSystemComponent particle = ParticleSystemComponent(
      // use AcceleratedParticle as just a position holder
      particle: AcceleratedParticle(
        lifespan: 2,
        position: position,
        child: SpriteAnimationParticle(
          animation: getBoomAnimation(),
          size: Vector2(200, 200),
        ),
      ),
    );
    add(particle);
  }


  ///
  /// Load up the sprite sheet with an even step time framerate
  SpriteAnimation getBoomAnimation() {
    const columns = 8;
    const rows = 8;
    const frames = columns * rows;
    final spriteImage = images.fromCache('particle/boom.png');
    final spritesheet = SpriteSheet.fromColumnsAndRows(
      image: spriteImage,
      columns: columns,
      rows: rows,
    );
    final sprites = List<Sprite>.generate(frames, spritesheet.getSpriteById);
    return SpriteAnimation.spriteList(sprites, stepTime: 0.1);
  }
}