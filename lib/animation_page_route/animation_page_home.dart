import 'package:cookbook/animation_page_route/animation_card_details.dart';
import 'package:cookbook/animation_page_route/animation_page_route.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AnimationPageHome extends StatelessWidget {
  const AnimationPageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Page Home'),
      ),
      body: Center(
        child: Column(
          children: [
            buildButtonNavigator(context, 'Animation Card Detail',
                const AnimationCardDetails1()),
            buildButtonNavigator(
                context, 'Animation Page Route', const AnimationPageRoute1()),
          ],
        ),
      ),
    );
  }
}
