import 'package:cookbook/main.dart';
import 'package:cookbook/physic_simulation/physic_simulation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'grid_numbers.dart';

final PhysicSimulationCubit physicSimulationCubit = PhysicSimulationCubit();

class DraggableCard extends StatefulWidget {
  const DraggableCard(
      {required this.child, super.key, required this.childSize});

  final Widget child;
  final Size childSize;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late double width = MediaQuery.of(context).size.width;
  late double height = MediaQuery.of(context).size.height;
  late final appbarOffset =
      Offset(0, Scaffold.of(context).appBarMaxHeight ?? 0);
  late final Offset centerPoint =
      Offset(width / 2 - size.width / 2, height / 2 - size.height / 2) +
          appbarOffset;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  late final gridNumbers =
      GridNumbers(width: width, size: size, height: height);

  Size get size => widget.childSize;

  late final offsetValueNotifier = ValueNotifier<Offset>(centerPoint);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addListener(_animationListener);
  }

  void _animationListener() {
    offsetValueNotifier.value = _animation.value;
  }

  @override
  void dispose() {
    _controller.removeListener(_animationListener);
    _controller.dispose();
    offsetValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          gridNumbers,
          ValueListenableBuilder(
            valueListenable: offsetValueNotifier,
            builder: (context, value, child) => Positioned(
              top: value.dy - appbarOffset.dy,
              left: value.dx,
              child: child!,
            ),
            child: Card(
              color: randomColor(),
              margin: EdgeInsets.zero,
              child: widget.child,
            ),
          )
        ],
      ),
    );
  }

  void _onPanDown(DragDownDetails details) {
    _controller.stop();
  }

  void _onPanEnd(DragEndDetails details) {
    _runAnimation(details.velocity.pixelsPerSecond);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    offsetValueNotifier.value += Offset(details.delta.dx, details.delta.dy);
    physicSimulationCubit.calculateNearestWidget(offsetValueNotifier.value);
  }

  void _runAnimation(Offset pixelsPerSecond) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: offsetValueNotifier.value,
        end: physicSimulationCubit.nearestWidgetOffset ?? centerPoint,
      ),
    );

    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / width;
    final unitsPerSecondY = pixelsPerSecond.dy / height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation);
  }
}
