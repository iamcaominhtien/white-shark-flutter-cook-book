import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

FadeTransition buildFadeTransition(Animation<double> animation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

ScaleTransition buildScaleTransition(
    Animation<double> animation, Widget child) {
  return ScaleTransition(
    scale: animation,
    alignment: Alignment.bottomCenter,
    child: child,
  );
}

SlideTransition slideTransitionWithCurve(
    Animation<double> animation, Widget child) {
  const begin = Offset(-1.0, 0.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOut,
  );
  final offsetAnimation = tween.animate(curvedAnimation);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

SlideTransition slideTransition(Animation<double> animation, Widget child) {
  const begin = Offset(-1.0, -1.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  final offsetAnimation = animation.drive(tween);
  return SlideTransition(
    position: offsetAnimation,
    child: Transform.rotate(
      angle: pi / 3 * (1 - animation.value),
      child: FadeTransition(opacity: animation, child: child),
    ),
  );
}

Route<Object?> buildRoute(Widget page) {
  return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return slideTransitionWithCurve(animation, child);
        // return slideTransition(animation, child);
        // return buildScaleTransition(animation, child);
        // return buildFadeTransition(animation, child);
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true);
}

class AnimationPageRoute1 extends StatelessWidget {
  const AnimationPageRoute1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Page Route 1'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, buildRoute(const AnimationPageRoute2Container()));
            },
            child: const Text('Page 1')),
      ),
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}

class AnimationPageRoute2Container extends StatefulWidget {
  const AnimationPageRoute2Container({super.key});

  @override
  State<AnimationPageRoute2Container> createState() =>
      _AnimationPageRoute2ContainerState();
}

class _AnimationPageRoute2ContainerState
    extends State<AnimationPageRoute2Container> {
  late double size = 0;
  final stream = StreamController<double?>.broadcast();
  late final width = MediaQuery.of(context).size.width;

  @override
  void dispose() {
    stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (mounted) {
          if (details.delta.dx < 0) {
            size -= details.delta.distance;
          } else {
            size += details.delta.distance;
          }
          size = min(size, 0);
          if (size <= 0) {
            stream.sink.add(size);
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (mounted) {
          if ((width + size) / width < 0.8) {
            Navigator.of(context).pop();
          } else {
            size = 0;
            stream.sink.add(size);
          }
        }
      },
      child: StreamBuilder<double?>(
          stream: stream.stream,
          builder: (context, snapshot) {
            return Transform.translate(
              offset: Offset(snapshot.data ?? 0.0, 0.0),
              // scale: snapshot.data??1.0,
              child: Opacity(
                opacity: mapValue(snapshot.data),
                child: const AnimationPageRoute2(),
              ),
            );
          }),
    );
  }

  double mapValue(double? d) {
    if (d == null) return 1.0;
    double value = (width - d.abs()) / width;
    return value;
  }
}

class AnimationPageRoute2 extends StatelessWidget {
  const AnimationPageRoute2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Page Route 2'),
      ),
      body: const Center(
        child: Text('Page 2'),
      ),
      backgroundColor: Colors.greenAccent,
    );
  }
}

class AnimationPageRoute3 extends StatelessWidget {
  const AnimationPageRoute3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Page Route 3'),
      ),
      body: const Center(
        child: Text('Page 3'),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
