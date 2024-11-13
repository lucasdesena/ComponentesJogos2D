import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image, Draggable;
import 'package:jogo_2d_udemy/games/circle_game.dart';

class Collidable extends CircleComponent with HasGameRef<CircleGame>, CollisionCallbacks {
  late Vector2 velocity;
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  Color _currentColor = Colors.cyan;
  bool _isWallHit = false;
  bool _isCollision = false;
  final double _speed = 200;

  /// direction vector split into constituetn x and y elements
  /// we start with the vector (1, 1) which is pointing down
  /// and to the right
  int xDirection = 1;
  int yDirection = 1;

  /// collision map which tracks all the MyCollidable objects that this
  /// objects has collided with and is still in the process of colliding
  /// We use this map to essentially figure out when a collision between
  /// objects has ended.
  Map<String, Collidable> collisions = <String, Collidable>{};

  Collidable(Vector2 position)
      : super(
          position: position,
          // size: Vector2.all(16),
          radius: 5,
          anchor: Anchor.center,
        ) {
    add(CircleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final center = gameRef.size / 2;
    velocity = (center - position)..scaleTo(_speed);
  }

  @override
  void update(double dt) {
    super.update(dt);

    /// check for any unresolved collisions
    ///
    /// We simply check of any object that this object has collided with
    /// has moved away further than the distance between touching objects.
    /// We create a list of keys that satisfy this condition and then they
    /// are removed from the map which signifies that the collision has ended.
    List keys = [];
    for (var other in collisions.entries) {
      Collidable otherObject = other.value;
      if (distance(otherObject) > size.x) {
        keys.add(other.key);
        // print('removing other: ${otherObject.hashCode}');
      }
    }

    /// remove any keys where the collision has ended.
    collisions.removeWhere((key, value) => keys.contains(key));

    x += xDirection * _speed * dt;
    y += yDirection * _speed * dt;

    /// get the bounding rectangle for our 'ball' object
    final rect = toRect();

    /// check for collision between the ball and the screen boundaries
    /// by testing each  component of the direction vector's x and y
    ///

    /// check if we passed the left or right screen edge
    ///
    if ((rect.left <= 0 && xDirection == -1) ||
        (rect.right >= gameRef.size.x && xDirection == 1)) {
      xDirection = xDirection * -1;
    }

    /// check if we passed the top or bottom screen edge
    ///
    if ((rect.top <= 0 && yDirection == -1) ||
        (rect.bottom >= gameRef.size.y && yDirection == 1)) {
      yDirection = yDirection * -1;
    }

    /// test for collision color to show collision between balls
    _currentColor = _isCollision ? _collisionColor : _defaultColor;
    if (_isCollision && !_isWallHit) {
      //print('distance update: $hashCode');
      _isCollision = false;
    }
    if (_isWallHit) {
      _isWallHit = false;
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
      /// Check if we have already seen this collision
      if (collisions.containsKey(other.hashCode.toString())) {
        /// we do, this is an ongoing collision: do nothing
      } else {
        /// this is a new collision so we add it to the mapp of current
        /// collisions
        collisions[other.hashCode.toString()] = other;

        /// we also start the bounce of the two balls by changing the direction
        /// of this ball
        xDirection = xDirection * -1;
        yDirection = yDirection * -1;
      }
      //print('Intersection Points for other hit: ${intersectionPoints}');
      //print('distance: ${distance(other)} $hashCode , ${other.hashCode}');
      _isCollision = true;
    }
  }
}