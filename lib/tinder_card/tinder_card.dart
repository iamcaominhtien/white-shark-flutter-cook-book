import 'dart:async';
import 'dart:math';

import 'package:cookbook/tinder_card/tinder_cards.dart';
import 'package:cookbook/tinder_card/tinder_cubit.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

class TinderCard extends StatefulWidget {
  const TinderCard({super.key, required this.callBack});

  final Function(Key? key, bool isMatch) callBack;

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard>
    with SingleTickerProviderStateMixin {
  late final child = sizedBox();
  final stream = StreamController<double>.broadcast();
  late final width = MediaQuery.of(context).size.width;
  double size = 0;

  // AnimationController
  AnimationController? _controller;
  static const _animationBegin = 0.0;
  static const _animationEnd = pi / 3;
  static const _animationDuration = Duration(milliseconds: 500);

  void _initAnimationController([bool isMatch = true]) {
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    late Tween<double> tween;
    if (isMatch) {
      tween = Tween(begin: _animationBegin, end: _animationEnd);
    } else {
      tween = Tween(begin: _animationBegin, end: -_animationEnd);
    }
    var curvedAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOut,
    );
    var animation = tween.animate(curvedAnimation);
    animation.addListener(() {
      stream.sink.add(animation.value);
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.callBack(widget.key, isMatch);
      }
    });
    _controller!.forward();
  }

  @override
  void dispose() {
    stream.close();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TinderCardsCubit, TinderCardsCubitState>(
      listener: (context, state) {
        if (state.removeWidget?.key == widget.key) {
          _initAnimationController(state.removeWidget!.isMatch);
        }
      },
      bloc: cubit,
      listenWhen: (previous, current) {
        return previous != current && current.removeWidget?.key == widget.key;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: StreamBuilder<double>(
            stream: stream.stream,
            builder: (context, snapshot) {
              return Transform.rotate(
                alignment: Alignment.bottomCenter,
                angle: (snapshot.data ?? 0),
                child: Opacity(
                    opacity: mapValue(snapshot.data ?? 0), child: child),
              );
            }),
      ),
    );
  }

  void _onHorizontalDragEnd(details) {
    if (mounted) {
      if ((size / (pi / 2)).abs() < 0.3) {
        size = 0;
        stream.sink.add(size);
      } else {
        if (size > 0) {
          stream.sink.add(pi / 2);
        } else {
          stream.sink.add(-pi / 2);
        }
        widget.callBack(widget.key, size > 0);
      }
    }
  }

  void _onHorizontalDragUpdate(details) {
    if (mounted) {
      if (details.delta.dx < 0) {
        size -= pi / 2 / 100;
      } else {
        size += pi / 2 / 100;
      }
      // size = min(size, 0);
      stream.sink.add(size);
    }
  }

  double mapValue(double d) {
    if ((d / (pi / 2)).abs() < 0.3) {
      return 1.0;
    }
    return max(min(((pi / 2 - d.abs()) / (pi / 2)).abs() + 0.3, 1.0), 0);
  }

  SizedBox sizedBox() {
    return SizedBox(
      width: min(MediaQuery.of(context).size.width * 0.8, 400),
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: randomColor(),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: Image.network(
                'https://images.unsplash.com/photo-1695132823558-1e27b91e34ee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHx8&auto=format&fit=crop&w=400&q=60',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${faker.person.firstName()}, ${(Random().nextInt(10) + 20)}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    faker.job.title(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    faker.address.city(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
