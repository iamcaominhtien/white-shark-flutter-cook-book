import 'package:cookbook/main.dart';
import 'package:cookbook/wave/wave_circle.dart';
import 'package:cookbook/wave/wave_love.dart';
import 'package:flutter/material.dart';

class WaveHome extends StatelessWidget {
  const WaveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wave Home')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildButtonNavigator(context, 'Wave circle', const WaveCircle()),
          buildButtonNavigator(context, 'Wave love', const WaveLove()),
        ],
      ),
    );
  }
}
