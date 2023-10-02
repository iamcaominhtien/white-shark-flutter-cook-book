//this example uses cubit to manage state. We can use provider, bloc, mobx, etc.

import 'dart:math';

import 'package:cookbook/event_calendar/events_model.dart';
import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCalendarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventsCalendarCubit extends Cubit<EventCalendarState> {
  final sampleCustomersForTable =
      List.generate(10, (index) => faker.person.name());
  final sampleCustomersForGrid = List.generate(
    10,
    (index) {
      final random = Random();
      final beginHour = 7 + random.nextInt(5);
      final endHour = beginHour + random.nextInt(5);
      final beginMinute = random.nextInt(60);
      final endMinute = beginMinute + random.nextInt(60);
      return Event(
        faker.person.name(),
        taskName: faker.lorem.sentence(),
        begin: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, beginHour, beginMinute),
        end: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, endHour, endMinute),
      );
    },
  );
  static const double heightOf15M = 25;
  static const double widthOfFirstColumn = 50;

  EventsCalendarCubit() : super(EventCalendarState());

  double withOfCellForTable(context) => sampleCustomersForTable.length > 2
      ? MediaQuery.of(context).size.width / 3
      : MediaQuery.of(context).size.width / sampleCustomersForTable.length -
          EventsCalendarCubit.widthOfFirstColumn /
              sampleCustomersForTable.length;

  double withOfCellForGrid(context) => sampleCustomersForGrid.length > 2
      ? MediaQuery.of(context).size.width / 3
      : MediaQuery.of(context).size.width / sampleCustomersForGrid.length -
          EventsCalendarCubit.widthOfFirstColumn /
              sampleCustomersForGrid.length;
}
