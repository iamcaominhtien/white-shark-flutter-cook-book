import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';

class RowLabels extends StatelessWidget {
  const RowLabels({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: EventsCalendarCubit.widthOfFirstColumn,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
          color: Colors.white,
          height: EventsCalendarCubit.heightOf15M * 4,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${index == 12 ? 12 : index % 12}:00',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  index < 12 ? 'am' : 'pm',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
        itemCount: 24,
      ),
    );
  }
}
