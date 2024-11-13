import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:jogo_2d_udemy/core/utils.dart';
import 'package:jogo_2d_udemy/games/square_game.dart';

/// Polygon-based asteroid shape example
class Asteroid extends PositionComponent with HasGameRef<SquareGame> {
  // default values
  //

  /// Vertices for the asteroid
  final vertices = ([
    Vector2(0.2, 0.8), // v1
    Vector2(-0.6, 0.6), // v2
    Vector2(-0.8, 0.2), // v3
    Vector2(-0.6, -0.4), // v4
    Vector2(-0.4, -0.8), // v5
    Vector2(0.0, -1.0), // v6
    Vector2(0.4, -0.6), // v7
    Vector2(0.8, -0.8), // v8
    Vector2(1.0, 0.0), // v9
    Vector2(0.4, 0.2), // v10
    Vector2(0.7, 0.6), // v1
  ]);

  late PolygonComponent asteroid;

  var velocity = Vector2(0, 25);
  var rotationSpeed = 0.3;
  var paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  @override
  //
  // render the shape
  void render(Canvas canvas) {
    super.render(canvas);
    asteroid.render(canvas);
  }

  @override
  //
  // update the inner state of the shape
  // in our case the position
  void update(double dt) {
    super.update(dt);
    // speed is refresh frequency independent
    position += velocity * dt;
    // add rotational speed update as well
    var angleDelta = dt * rotationSpeed;
    angle = (angle - angleDelta) % (2 * pi);

    /// check if the object is out of bounds
    ///
    /// if it is out-of-bounds then remove it from the game engine
    /// note the usage of gameRef to get access to the game engine
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      gameRef.remove(this);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    asteroid = PolygonComponent(
        vertices, // the vertices
        size: size, // the actual size of the shape
        position: position, // the position on the screen
        paint: paint);
    anchor = Anchor.center;
  }
}