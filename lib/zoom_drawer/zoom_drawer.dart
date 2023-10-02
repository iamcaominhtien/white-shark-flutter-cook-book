import 'dart:math';

import 'package:cookbook/zoom_drawer/zoom_drawer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_menu.dart';
import 'zoom_drawer_cubit.dart';

final zoomDrawerCubit = ZoomDrawerCubit();

class ZoomDrawer extends StatefulWidget {
  const ZoomDrawer({
    super.key,
    this.maxSlideScale = 0.7,
    this.minSizeScale = 0.8,
    this.horizontalGestureScale = 0.5,
    this.secondColor,
    this.thirdColor,
  });

  final double maxSlideScale;
  final double minSizeScale;
  final double horizontalGestureScale;
  final Color? secondColor;
  final Color? thirdColor;

  @override
  State<ZoomDrawer> createState() => _ZoomDrawerState();
}

class _ZoomDrawerState extends State<ZoomDrawer> with TickerProviderStateMixin {
  static const _offsetBegin = Offset(1.0, 0.0); //x: scale, y: slide
  late final _offsetEnd =
      Offset(max(widget.minSizeScale, 0), min(widget.maxSlideScale, 1.0));
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  static const _spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);
  // Offset _position = _offsetBegin;
  final _offsetValueNotifier = ValueNotifier<Offset>(_offsetBegin);

  bool canDrag = true;

  late final _body = _buildBody();
  late final _drawer = DrawerMenu(_offsetEnd.dy, 1 - _offsetEnd.dx);
  late final thirdScreen = _ThirdScreen(widget: widget);
  late final secondScreen = _SecondScreen(widget: widget);

  double get width => MediaQuery.of(context).size.width;

  double get height => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    zoomDrawerCubit.resetDrawer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    //x: scale, y: slide
    _createAnimationForOpening();

    _animationController.addListener(_animationListener);
  }

  @override
  void dispose() {
    _animationController.removeListener(_animationListener);
    _animationController.dispose();
    _offsetValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ZoomDrawerCubit, ZoomDrawerState>(
      listener: (context, state) {
        if (state.openDrawer == true) {
          _openDrawer();
        } else {
          _closeDrawer();
        }
      },
      listenWhen: (previous, current) =>
          previous.openDrawerRequestTracer != current.openDrawerRequestTracer,
      bloc: zoomDrawerCubit,
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: _offsetValueNotifier,
          builder: (context, value, child) => Stack(
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Transform.translate(
                  offset: Offset(
                    (-_offsetEnd.dy + value.dy) * width,
                    0,
                  ),
                  child: _drawer,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  value.dy * width,
                  0,
                ),
                child: Transform.scale(
                  alignment: Alignment.centerLeft,
                  scale: value.dx,
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(
                          value.dy / _offsetEnd.dy * -50,
                          0,
                        ),
                        child: Transform.scale(
                          scaleY: _scaleValueForBehindScreen(value.dx, 0.9),
                          child: thirdScreen,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                          value.dy / _offsetEnd.dy * -25,
                          0,
                        ),
                        child: Transform.scale(
                          scaleY: _scaleValueForBehindScreen(value.dx, 0.95),
                          child: secondScreen,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40 * value.dy),
                        child: _body,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _scaleValueForBehindScreen(double value, double maxValue) =>
      ((1 - maxValue) * value + (maxValue - _offsetEnd.dx)) /
      (1 - _offsetEnd.dx);

  void _createAnimationForOpening() {
    _animation = Tween<Offset>(begin: _offsetBegin, end: _offsetEnd).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _createAnimationForClosing() {
    _animation = Tween<Offset>(begin: _offsetEnd, end: _offsetBegin).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _closeDrawer() {
    _animationController.reset();
    _createAnimationForClosing();
    _animationController.forward();
  }

  void _openDrawer() {
    _animationController.reset();
    _createAnimationForOpening();
    _animationController.forward();
  }

  void _animationListener() {
    _offsetValueNotifier.value = _animation.value;
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    _animation = _animationController.drive(
      Tween<Offset>(
        begin: _offsetValueNotifier.value,
        end: zoomDrawerCubit.state.openDrawer ? _offsetEnd : _offsetBegin,
      ),
    );

    final unitsPerSecondX = details.velocity.pixelsPerSecond.dx / width;
    final unitsPerSecondY = details.velocity.pixelsPerSecond.dy / height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    final simulation = SpringSimulation(_spring, 0, 1, -unitVelocity);
    _animationController.animateWith(simulation);
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    late Offset value;
    if (details.delta.dx < 0) {
      zoomDrawerCubit.setDrawer(false);
      value = const Offset(0.2 / 60, -0.5 / 60);
    } else {
      zoomDrawerCubit.setDrawer(true);
      value = const Offset(-0.2 / 60, 0.5 / 60);
    }
    if (!_checkInvalidPosition(_offsetValueNotifier.value + value)) {
      if (details.delta.dx < 0) {
        _offsetValueNotifier.value = _offsetBegin;
      } else {
        _offsetValueNotifier.value = _offsetEnd;
      }
    } else {
      _offsetValueNotifier.value += value;
    }
  }

  bool _checkInvalidPosition(Offset offset) {
    if (_offsetBegin.dx < offset.dx || offset.dx < _offsetEnd.dx) return false;
    if (_offsetBegin.dy > offset.dy || offset.dy > _offsetEnd.dy) return false;
    return true;
  }

  Widget _buildBody() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (canDrag == false) {
          canDrag =
              details.localPosition.dx < width * widget.horizontalGestureScale;
        }
        if (canDrag) {
          if (canDrag) onHorizontalDragUpdate(details);
        }
      },
      onHorizontalDragEnd: (details) {
        if (canDrag) {
          onHorizontalDragEnd(details);
          canDrag = false;
        }
      },
      child: const ZoomDrawerContainer(),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen({
    required this.widget,
  });

  final ZoomDrawer widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.secondColor ??
            Theme.of(context).colorScheme.primary.withGreen(0),
      ),
    );
  }
}

class _ThirdScreen extends StatelessWidget {
  const _ThirdScreen({
    required this.widget,
  });

  final ZoomDrawer widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.thirdColor ??
            Theme.of(context)
                .colorScheme
                .primary
                .withGreen(100)
                .withOpacity(0.7),
      ),
    );
  }
}
