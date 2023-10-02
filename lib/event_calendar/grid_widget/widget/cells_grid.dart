import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'customer_times_blocks.dart';

class CellsGrid extends StatelessWidget {
  const CellsGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: EventsCalendarCubit.heightOf15M * 4 * 24,
      margin: const EdgeInsets.only(top: EventsCalendarCubit.heightOf15M * 4),
      padding:
          const EdgeInsets.only(left: EventsCalendarCubit.widthOfFirstColumn),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: List.generate(
            context.read<EventsCalendarCubit>().sampleCustomersForGrid.length,
            (index) {
          return CustomerTimesBlocks(context
              .read<EventsCalendarCubit>()
              .sampleCustomersForGrid[index]);
        }),
      ),
    );
  }
}
