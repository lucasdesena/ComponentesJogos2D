import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Particle Generator Function for accelarated particles with a random
/// downward speed vector
class ParticleThree {
  // A pallete to paint over the "sky"
  static final paints = [
    Colors.amber,
    Colors.amberAccent,
    Colors.red,
    Colors.redAccent,
    Colors.yellow,
    Colors.yellowAccent,
    // Adds a nice "lense" tint
    // to overall effect
    Colors.blue,
  ].map((color) => Paint()..color = color).toList();
  // random number generator
  static final Random rnd = Random();

  /// Particle Engine routine
  /// Generates a set of particles wrapped in a single ParticleComponent
  ///
  static ParticleSystemComponent createParticleEngine({required Vector2 position}) {
    return ParticleSystemComponent(
      particle:       Particle.generate(
        count: 10,
        lifespan: 2,
        generator: (i) {
          final initialSpeed = randomVector()..scale(200);
          final deceleration = initialSpeed * -1;
          final gravity = Vector2(0, 40);

          return AcceleratedParticle(
            position: position,
            speed: initialSpeed,
            acceleration: deceleration + gravity,
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = getRandomListElement(paints);
                // Override the color to dynamically update opacity
                paint.color = paint.color.withOpacity(1 - particle.progress);
                //print("<particle progress> ${particle.progress}");
                //print("<particle paint> ${paint.toString()}");

                canvas.drawCircle(
                  Offset.zero,
                  // Closer to the end of lifespan particles
                  // will turn into larger glaring circles
                  rnd.nextDouble() * particle.progress > .6
                      ? rnd.nextDouble() * (50 * particle.progress)
                      : 2 + (3 * particle.progress),
                  paint,
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Generates a true random vector in all directions
  ///
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

  /// Returns a random element from a given list
  ///
  static T getRandomListElement<T>(List<T> list) {
    return list[rnd.nextInt(list.length)];
  }
}