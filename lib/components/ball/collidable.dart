import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Image, Draggable;
import 'package:jogo_2d_udemy/components/ball/lifebar_text.dart';
import 'package:jogo_2d_udemy/games/ball_game.dart';

class Collidable extends CircleComponent with HasGameRef<BallGame>, CollisionCallbacks {
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  Color _currentColor = Colors.cyan;
  bool _isWallHit = false;
  bool _isCollision = false;
  late double _speed;
  late LifeBarText _healthText;

  /// direction vector split into constituetn x and y elements
  /// we start with the vector (1, 1) which is pointing down
  /// but do note that since we are randomly generating the direction
  /// in this exercise the initial values are irrelevant.
  int xDirection = 1;
  int yDirection = 1;

  /// The life value of the ball.
  /// Starts with this number (10) and then is depleted at each collision by 1
  int _objectLifeValue = 100;

  /// The map of ids of the objects we have recently collided with
  ///
  Map<String, Collidable> collisions = <String, Collidable>{};

  /// Default constructor with hardcoded radius and a hitbox definition
  Collidable(
      Vector2 position, Vector2 velocity, double speed, int ordinalNumber)
      : super(position: position, radius: 20, anchor: Anchor.center) {
    xDirection = velocity.x.toInt();
    yDirection = velocity.y.toInt();
    _speed = speed;
    add(CircleHitbox());
    _healthText = LifeBarText(ordinalNumber)
      ..x = 0
      ..y = -size.y / 2;
  }

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.load('ball/ball_bounce_off_ball.ogg');
    add(_healthText);
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    /// check for any unresolved collisions
    ///
    List keys = [];
    for (var other in collisions.entries) {
      Collidable otherObject = other.value;
      if (distance(otherObject) > size.x) {
        keys.add(other.key);
      }
    }
    collisions.removeWhere((key, value) => keys.contains(key));

    x += xDirection * _speed * dt;
    y += yDirection * _speed * dt;

    /// get the bounding rectangle for our 'ball' object
    final rect = toRect();

    /// check for collision between the ball and the screen boundaries
    /// by testing each  component of the direction vector's x and y
    ///
    ///

    /// check if we passed the left or right screen edge
    ///
    if ((rect.left <= 0 && xDirection == -1) ||
        (rect.right >= gameRef.size.x && xDirection == 1)) {
      xDirection = xDirection * -1;
      _isWallHit = true;
    }

    /// check if we passed the top or bottom screen edge
    ///
    if ((rect.top <= 0 && yDirection == -1) ||
        (rect.bottom >= gameRef.size.y && yDirection == 1)) {
      yDirection = yDirection * -1;
      _isWallHit = true;
      //print('rect size: $rect screen size: ${gameRef.size}');
    }

    /// test for collision color to show collision between balls
    _currentColor = _isCollision ? _collisionColor : _defaultColor;
    if (_isCollision) {
      /// reduce lifespan
      _objectLifeValue -= 10;
      // reset
      _isCollision = false;
    }
    if (_isWallHit) {
      /// reduce lifespan
      _objectLifeValue -= 10;
      _isWallHit = false;
    }

    _healthText.healthData = _objectLifeValue;

    /// remove this objects if its life has ended.
    if (_objectLifeValue <= 0) {
      parent?.remove(this);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    paint = Paint()..color = _currentColor;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Collidable) {
      /// Add the id of the object we have collided with to our set of
      /// currently happening collisions.
      ///
      ///
      ///
      if (collisions.containsKey(other.hashCode.toString())) {
        /// do nothing, we have handled this collision already
        ///
      } else {
        /// add the object's id to the map and store the object reference
        collisions[other.hashCode.toString()] = other;

        /// bounce away from the object we collided with
        xDirection = xDirection * -1;
        yDirection = yDirection * -1;

        /// create an entry in our collosions set to see if these two objects
        /// have already generated a 'bounce' sound
        ///
        /// The reason for another collision entry in a separate set, is that
        /// we want to make sure that the sounds is only played once, even
        /// though we will get at least 2 collision notifcations for any
        /// 2 objects colliding
        ///
        String collisionKey;
        if (hashCode > other.hashCode) {
          collisionKey = other.hashCode.toString() + hashCode.toString();
        } else {
          collisionKey = hashCode.toString() + other.hashCode.toString();
        }
        if (gameRef.observedCollisions.contains(collisionKey)) {
          /// remove it we are done
          gameRef.observedCollisions.remove(collisionKey);
        } else {
          /// add it to our set block the 2nd one from maing the bounce sound
          gameRef.observedCollisions.add(collisionKey);

          /// generate efx sound
          FlameAudio.play('ball/ball_bounce_off_ball.ogg');
        }

        _isCollision = true;
      }
    }
  }
}