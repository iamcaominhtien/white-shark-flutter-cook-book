import 'package:cookbook/event_calendar/grid_widget/widget/task_card.dart';
import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersTasks extends StatelessWidget {
  const CustomersTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: context
          .read<EventsCalendarCubit>()
          .sampleCustomersForGrid
          .map((event) {
        double positionTop = (event.begin.hour * 60 + event.begin.minute) /
            15 *
            EventsCalendarCubit.heightOf15M;
        double leftPosition = context
                    .read<EventsCalendarCubit>()
                    .sampleCustomersForGrid
                    .indexOf(event) *
                context.read<EventsCalendarCubit>().withOfCellForGrid(context) +
            EventsCalendarCubit.widthOfFirstColumn;
        double height = event.fifteenRange * EventsCalendarCubit.heightOf15M;
        return Positioned(
          top: positionTop,
          left: leftPosition + 2,
          height: height,
          child: TaskCard(event),
        );
      }).toList(),
    );
  }
}
