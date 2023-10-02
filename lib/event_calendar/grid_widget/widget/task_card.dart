import 'package:cookbook/event_calendar/events_model.dart';
import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
    this.event, {
    super.key,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('tapped task');
      },
      child: Container(
        width:
            context.read<EventsCalendarCubit>().withOfCellForGrid(context) - 3,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Text(
                '${timeFormat(event.begin)} - ${timeFormat(event.end)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var maxLines =
                      calculateMaxLines(constraints.maxHeight - 5, 13, 1.5);
                  if (maxLines <= 0) {
                    maxLines = -1;
                  }
                  if (maxLines < 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(event.taskName,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: maxLines
                        // maxLines: 10000,
                        ),
                  );
                },
              ),
            ),
          ],
        ),
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
