import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TinderCardsCubitState extends Equatable {
  final ({Key? key, bool isMatch})? removeWidget;

  const TinderCardsCubitState({this.removeWidget});

  //copyWith
  TinderCardsCubitState copyWith({({Key? key, bool isMatch})? removeWidget}) =>
      TinderCardsCubitState(removeWidget: removeWidget ?? this.removeWidget);

  @override
  List<Object?> get props => [removeWidget];
}

class TinderCardsCubit extends Cubit<TinderCardsCubitState> {
  TinderCardsCubit() : super(const TinderCardsCubitState());

  void removeWidget(({Key? key, bool isMatch})? item) =>
      emit(state.copyWith(removeWidget: item));
}
