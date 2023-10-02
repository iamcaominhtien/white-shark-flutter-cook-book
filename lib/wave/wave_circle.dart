import 'package:flutter/material.dart';

class WaveCircle extends StatefulWidget {
  const WaveCircle({super.key});

  @override
  State<WaveCircle> createState() => _WaveCircleState();
}

class _WaveCircleState extends State<WaveCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late final List<Widget> _waves = [_createWave()];
  late final child = buildChild();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 1, end: 1.2).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCubic));
    _animationController.addStatusListener(_statusListener);
    _animationController.forward();
  }

  @override
  void dispose() {
    // _timer.cancel();
    _animationController.removeStatusListener(_statusListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wave circle')),
      body: Stack(
        children: [
          for (var item in _waves)
            Align(
              child: item,
            ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => Transform.scale(
              scale: _animation.value,
              child: child!,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Align buildChild() {
    return Align(
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void removeItem() {
    _waves.removeAt(0);
  }

  _Wave _createWave() {
    return _Wave(
      key: GlobalKey(),
      callBack: removeItem,
    );
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _waves.add(_createWave());
      setState(() {});
      _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _animationController.forward();
    }
  }
}

class _Wave extends StatefulWidget {
  const _Wave({super.key, required this.callBack});

  final Function() callBack;

  @override
  State<_Wave> createState() => _WaveState();
}

class _WaveState extends State<_Wave> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final circleAvatar = buildCircleAvatar();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10000));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.addStatusListener(_statusListener);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_statusListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: 1 - _animation.value,
        child: Transform.scale(
          scale: _animation.value * 10,
          child: child!,
        ),
      ),
      child: circleAvatar,
    );
  }

  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
      radius: 72,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      // backgroundColor: randomColor(),
    );
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.callBack.call();
  }
}
