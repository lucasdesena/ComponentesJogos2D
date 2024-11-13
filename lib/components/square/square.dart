import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:jogo_2d_udemy/components/square/life_bar.dart';

//
//
// Simple component shape example of a square component
class Square extends PositionComponent {
  // default values
  //
  var velocity = Vector2(0, 25);
  var rotationSpeed = 0.3;
  var squareSize = 128.0;
  var color = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  late LifeBar lifeBar;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
    createLifeBar();
  }

  @override
  //
  // render the shape
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), color);
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
    angle = (angle + angleDelta) % (2 * pi);
  }

  //
  //
  // Create a rudimentary lifebar shape
  createLifeBar() {
    lifeBar = LifeBar.initData(size,
        size: Vector2(size.x - 10, 5), placement: LifeBarPlacement.center);
    //
    // add all lifebar element to the children of the Square instance
    add(lifeBar);
  }

  /// Method for communicating life state information to the class object
  ///
  processHit() {
    lifeBar.decrementCurrentLifeBy(10);
  }
}