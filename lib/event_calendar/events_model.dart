import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final DateTime begin;
  final DateTime end;
  final String taskName;
  final String customerName;

  const Event(this.customerName,
      {required this.begin, required this.end, required this.taskName});

  int get startHour => begin.hour;

  int get endHour => end.hour;

  double get fifteenRange => end.difference(begin).inMinutes / 15;

  @override
  List<Object?> get props => [begin, end, taskName, customerName];
}
