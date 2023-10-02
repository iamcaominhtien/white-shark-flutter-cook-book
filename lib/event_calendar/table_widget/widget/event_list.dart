import 'package:cookbook/event_calendar/events_model.dart';
import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventLists extends StatefulWidget {
  const EventLists({
    super.key,
  });

  @override
  State<EventLists> createState() => _EventListsState();
}

class _EventListsState extends State<EventLists> {
  late final double withOfCell =
      context.read<EventsCalendarCubit>().withOfCellForTable(context);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 0,
      left: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _EventCard(
            withOfCell: withOfCell,
            customerIndex: 0,
            event: Event(
                context.read<EventsCalendarCubit>().sampleCustomersForTable[0],
                begin: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 8, 10),
                end: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 8, 55),
                taskName: faker.conference.name()),
          ),
          _EventCard(
            withOfCell: withOfCell,
            customerIndex: 0,
            event: Event(
                context.read<EventsCalendarCubit>().sampleCustomersForTable[0],
                begin: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 9, 18),
                end: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 12, 55),
                taskName: faker.conference.name()),
          ),
          _EventCard(
            withOfCell: withOfCell,
            customerIndex: 1,
            event: Event(
                context.read<EventsCalendarCubit>().sampleCustomersForTable[1],
                begin: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 8, 30),
                end: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 10, 0),
                taskName: faker.conference.name()),
          ),
          _EventCard(
            withOfCell: withOfCell,
            customerIndex: 5,
            event: Event(
                context.read<EventsCalendarCubit>().sampleCustomersForTable[1],
                begin: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 8, 30),
                end: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 10, 0),
                taskName: faker.conference.name()),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.withOfCell,
    required this.customerIndex,
    required this.event,
  });

  final double withOfCell;
  final int customerIndex;
  final Event event;

  @override
  Widget build(BuildContext context) {
    final indexBegin = event.begin.hour * 4 + event.begin.minute / 15;
    final indexEnd = event.end.hour * 4 + event.end.minute / 15;
    final height = EventsCalendarCubit.heightOf15M * (indexEnd - indexBegin);
    return Positioned(
      //top: each cell has 4 rows = 1 hour, use heightOf15M
      //lef: represent for a customer (use widthOfCell)
      top: indexBegin * EventsCalendarCubit.heightOf15M,
      left: customerIndex * withOfCell,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onTap: () {},
        child: Container(
            margin: const EdgeInsets.only(left: 2),
            width: withOfCell - 4,
            height: height,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${timeFormat(event.begin)} - ${timeFormat(event.end)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Text(event.taskName,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            calculateMaxLines(constraints.maxHeight, 13, 1.5)
                        // maxLines: 10000,
                        ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  String timeFormat(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  int calculateMaxLines(double height, int fontSize, double textHeight) {
    return (height / (fontSize * textHeight)).floor();
  }
}
