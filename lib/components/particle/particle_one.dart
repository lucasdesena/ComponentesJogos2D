import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Particle Generator Function for accelarated particles with a random
/// downward speed vector
class ParticleOne extends FlameGame{
  static final Random _random = Random();

  ///Create engine particels
  static ParticleSystemComponent createParticleEngine({required Vector2 position}) {
    return ParticleSystemComponent(
      particle: AcceleratedParticle(
        lifespan: 0.5,
        position: position,
        //Create a downward shooting particle
        speed: Vector2(
          _random.nextDouble() * 200 - 100,
          max(_random.nextDouble(), 0.1) * 10,
        ),
        child: CircleParticle(
          radius: 1.0,
          //Random color between yellow and red
          paint: Paint()
            ..color =
                Color.lerp(Colors.yellow, Colors.red, _random.nextDouble())!,
        ),
      ),
    );
  }
}