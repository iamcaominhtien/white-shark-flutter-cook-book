import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';

class RowLabel extends StatelessWidget {
  const RowLabel({
    super.key,
    required this.indexRow,
  });

  final int indexRow;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: SizedBox(
        width: EventsCalendarCubit.widthOfFirstColumn,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${indexRow % 12}:00',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                indexRow < 12 ? 'am' : 'pm',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
