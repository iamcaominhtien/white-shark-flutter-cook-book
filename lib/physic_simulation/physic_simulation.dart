import 'package:flutter/material.dart';

import 'draggable_card.dart';

class PhysicSimulation extends StatefulWidget {
  const PhysicSimulation({super.key});

  @override
  State<PhysicSimulation> createState() => _PhysicSimulationState();
}

class _PhysicSimulationState extends State<PhysicSimulation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physic simulation'),
      ),
      body: const DraggableCard(
        childSize: Size(128, 128),
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}
