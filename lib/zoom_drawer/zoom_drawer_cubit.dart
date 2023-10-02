import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomDrawerCubit extends Cubit<ZoomDrawerState> {
  ZoomDrawerCubit() : super(const ZoomDrawerState());

  void setDrawer(bool status) {
    if (status != state.openDrawer) {
      emit(state.copyWith(openDrawer: status));
    }
  }

  void resetDrawer() {
    emit(state.copyWith(openDrawer: false));
  }

  void toggleDrawer() {
    emit(state.copyWith(
        openDrawer: !state.openDrawer,
        openDrawerRequestTracer: DateTime.now()));
  }

  void changePage(IconData page) {
    emit(state.copyWith(page: page));
  }
}

class ZoomDrawerState extends Equatable {
  final bool openDrawer;
  final DateTime? openDrawerRequestTracer;
  final IconData page;

  const ZoomDrawerState(
      {this.openDrawer = false,
      this.openDrawerRequestTracer,
      this.page = Icons.home});

  @override
  List<Object?> get props => [openDrawer, openDrawerRequestTracer, page];

  //copyWith
  ZoomDrawerState copyWith(
      {bool? openDrawer, DateTime? openDrawerRequestTracer, IconData? page}) {
    return ZoomDrawerState(
        openDrawer: openDrawer ?? this.openDrawer,
        openDrawerRequestTracer:
            openDrawerRequestTracer ?? this.openDrawerRequestTracer,
        page: page ?? this.page);
  }
}
