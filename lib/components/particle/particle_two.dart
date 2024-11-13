import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ParticleTwo extends FlameGame{
  ///Create engine particels
  static ParticleSystemComponent createParticleEngine({required Vector2 position}) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 30,
        lifespan: 3,
        generator: (i) => AcceleratedParticle(
          //acceleration: Vector2.random()..scale(200),
          acceleration: randomVector()..scale(100),
          position: position,
          child: CircleParticle(
            paint: Paint()..color = Colors.red,
            radius: 2,
          ),
        ),
      ),
    );
  }

  static Vector2 randomVector() {
    Vector2 result;
    final Random rnd = Random();
    const int min = -1;
    const int max = 1;
    double numX = min + ((max - min) * rnd.nextDouble());
    double numY = min + ((max - min) * rnd.nextDouble());
    debugPrint("Random Vector $numX, $numY");
    result = Vector2(numX, numY);
    return result;
  }
}