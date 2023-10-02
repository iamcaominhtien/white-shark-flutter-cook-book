import 'package:cookbook/physic_simulation/physic_simulation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import 'draggable_card.dart';

class GridNumberWidget extends StatefulWidget {
  const GridNumberWidget({
    super.key,
    required this.size,
    required this.index,
  });

  final Size size;
  final int index;

  @override
  State<GridNumberWidget> createState() => _GridNumberWidgetState();
}

class _GridNumberWidgetState extends State<GridNumberWidget>
    with SingleTickerProviderStateMixin {
  final key = GlobalKey();

  Offset? get globalPosition =>
      (key.currentContext?.findRenderObject() as RenderBox?)
          ?.localToGlobal(Offset.zero);

  late AnimationController _controller;
  late Animation<double> _animation;

  bool? isForward;

  @override
  void initState() {
    super.initState();
    physicSimulationCubit.addKey(key);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 1, end: 40).animate(_controller);
  }

  void forward() {
    _controller.forward();
  }

  void reverse() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhysicSimulationCubit, PhysicSimulationState>(
      bloc: physicSimulationCubit,
      listener: (context, state) {
        if (isForward == true) {
          forward();
        } else if (isForward == false) {
          reverse();
        }
      },
      listenWhen: (previous, current) {
        if (previous.nearestWidget != key && current.nearestWidget != key) {
          return false;
        }

        //forward: previous is not key and current is key
        if (previous.nearestWidget != key && current.nearestWidget == key) {
          isForward = true;
        }

        //reverse: previous is key and current is not key
        if (previous.nearestWidget == key && current.nearestWidget != key) {
          isForward = false;
        }

        //do not update animation: previous is key and current is key
        if (previous.nearestWidget == key && current.nearestWidget == key) {
          isForward = null;
          return false;
        }

        return true;
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          key: key,
          width: widget.size.width,
          height: widget.size.height,
          color: randomColor(),
          child: Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Transform.scale(
                scale: _animation.value,
                child: child!,
              ),
              child: Text(
                widget.index.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
