import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jogo_2d_udemy/games/airplane_game.dart';
import 'package:jogo_2d_udemy/games/ball_game.dart';
import 'package:jogo_2d_udemy/games/parralax_game.dart';
import 'package:jogo_2d_udemy/games/particle_game.dart';
import 'package:jogo_2d_udemy/games/square_game.dart';

class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> games = ['Airplane', 'Square', 'Parralax', 'Particle', 'Circle'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Games'),
      ),
      body: Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          itemCount: games.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            late VoidCallback onPressedAction;

            switch (games[index]) {
              case "Airplane":
                onPressedAction = () => Get.to(() => GameWidget(game: AirplaneGame()));
                break;
              case "Square":
                onPressedAction = () => Get.to(() => GameWidget(game: SquareGame()));
                break;
              case "Parralax":
                onPressedAction = () {
                  Flame.device.setLandscape();
                  Get.to(() => GameWidget(game: ParralaxGame()))?.then((_){
                    Flame.device.setPortrait();
                  });
                };
                break;
              case "Particle":
                onPressedAction = () => Get.to(() => GameWidget(game: ParticleGame()));
                break;
              case "Circle":
                onPressedAction = () => Get.to(() => GameWidget(game: BallGame()));
                break;
              default:
                onPressedAction = () {};
            }

            return ElevatedButton(
              onPressed: onPressedAction,
              child: Text(games[index]),
            );
          },
        ),
      ),
    );
  }
}