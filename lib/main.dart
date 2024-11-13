import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jogo_2d_udemy/choice_page.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(
    const Jogos2DUdemy(),
  );
}

class Jogos2DUdemy extends StatelessWidget {
  const Jogos2DUdemy({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Jogos 2D Udemy',
      debugShowCheckedModeBanner: false,
      home: ChoicePage(),
    );
  }
}


