import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/tank_war_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TankWarApp());
}

class TankWarApp extends StatelessWidget {
  const TankWarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tank War',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const GamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final TankWarGame game;

  @override
  void initState() {
    super.initState();
    game = TankWarGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: game,
        autofocus: true,
        focusNode: FocusNode(),
      ),
    );
  }
}