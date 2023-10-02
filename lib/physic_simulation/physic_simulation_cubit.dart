import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhysicSimulationState extends Equatable {
  final Key? nearestWidget;

  const PhysicSimulationState({this.nearestWidget});

  @override
  List<Object?> get props => [nearestWidget];

  PhysicSimulationState copyWith({Key? nearestWidget}) {
    return PhysicSimulationState(
        nearestWidget: nearestWidget ?? this.nearestWidget);
  }
}

class PhysicSimulationCubit extends Cubit<PhysicSimulationState> {
  PhysicSimulationCubit() : super(const PhysicSimulationState());

  Set keys = <GlobalKey>{};

  void addKey(Key key) {
    keys.add(key);
  }

  void calculateNearestWidget(Offset offset) {
    double minDistance = double.infinity;
    GlobalKey? nearestWidget;
    for (GlobalKey key in keys) {
      final Offset? widgetOffset = _globalPosition(key);
      if (widgetOffset == null) continue;
      final num distance = pow(widgetOffset.dx - offset.dx, 2) +
          pow(widgetOffset.dy - offset.dy, 2);
      if (distance < minDistance) {
        minDistance = distance.toDouble();
        nearestWidget = key;
      }
    }
    if (nearestWidget != state.nearestWidget) {
      emit(state.copyWith(nearestWidget: nearestWidget));
    }
  }

  Offset? _globalPosition(GlobalKey? key) =>
      (key?.currentContext?.findRenderObject() as RenderBox?)
          ?.localToGlobal(Offset.zero);

  Offset? get nearestWidgetOffset {
    if (state.nearestWidget == null) return null;
    return _globalPosition(state.nearestWidget as GlobalKey);
  }
}
