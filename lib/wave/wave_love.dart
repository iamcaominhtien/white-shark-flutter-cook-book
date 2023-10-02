import 'package:flutter/material.dart';

class WaveLove extends StatefulWidget {
  const WaveLove({super.key});

  @override
  State<WaveLove> createState() => _WaveLoveState();
}

class _WaveLoveState extends State<WaveLove>
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
      appBar: AppBar(title: const Text('Wave love')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox.expand(),
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

  Align buildChild() {
    return const Align(
      child: LoveShape(200),
    );
  }
}

class LoveShape extends StatelessWidget {
  const LoveShape(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, size / 2),
      child: Transform.scale(
        scale: 2.5,
        child: CustomPaint(
          size: Size(size, size),
          painter: LovePainter(),
        ),
      ),
    );
  }
}

class LovePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    // ..strokeWidth = 2
    // ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, size.height / 5);
    path.cubicTo(size.width / 2, 0, size.width, size.height / 5, size.width / 2,
        size.height / 2);
    path.cubicTo(
        0, size.height / 5, size.width / 2, 0, size.width / 2, size.height / 5);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
  late final loveShape = buildLoveShape();

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
        opacity: (1 - _animation.value) * 0.5,
        child: Transform.scale(
          scale: _animation.value * 10,
          child: child!,
        ),
      ),
      child: loveShape,
    );
  }

  LoveShape buildLoveShape() {
    return const LoveShape(200 * 1.2);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.callBack.call();
  }
}
