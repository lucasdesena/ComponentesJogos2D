import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jogo_2d_udemy/components/square/square.dart';

class SquareGame extends FlameGame with DoubleTapDetector, TapCallbacks {
  bool running = true;

  //
  // text rendering const
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 14.0,
      fontFamily: 'Awesome Font',
    ),
  );

  @override
  //
  //
  // Process user's single tap (tap up)
  void onTapUp(TapUpEvent event) {
    // location of user's tap
    // final touchPoint = info.eventPosition.game;
    final touchPoint = event.localPosition;
    debugPrint("<user tap> touchpoint: $touchPoint");

    //
    // handle the tap action
    //
    // check if the tap location is within any of the shapes on the screen
    // and if so remove the shape from the screen
    final handled = children.any((component) {
      if (component is Square && component.containsPoint(touchPoint)) {
        if(component.lifeBar.currentLife <= 10) remove(component);
        component.processHit();
        component.velocity.negate();
        return true;
      }
      return false;
    });

    //
    // this is a clean location with no shapes
    // create and add a new shape to the component tree under the FlameGame
    if (!handled) {
      add(Square()
        ..position = touchPoint
        ..squareSize = 45.0
        ..velocity = Vector2(0, 1).normalized() * 25
        ..color = (Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2));
      // add(Asteroid()
      //   ..position = touchPoint
      //   ..size = Vector2(100, 100)
      //   ..velocity = Vector2(0, 1).normalized() * 25
      //   ..paint = (BasicPalette.red.paint()
      //     ..style = PaintingStyle.stroke
      //     ..strokeWidth = 1));
    }
  }

  @override
  void onDoubleTap() {
    if (running) {
      pauseEngine();
    } else {
      resumeEngine();
    }

    running = !running;
  }

  @override
  void render(Canvas canvas) {
    textPaint.render(canvas, "objects active: ${children.whereType<Square>().length}", Vector2(10, 20));
    super.render(canvas);
  }
}