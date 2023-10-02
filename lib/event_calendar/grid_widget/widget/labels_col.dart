import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LabelsColumn extends StatelessWidget {
  const LabelsColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: EventsCalendarCubit.heightOf15M * 4,
      padding:
          const EdgeInsets.only(left: EventsCalendarCubit.widthOfFirstColumn),
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(
              width: context
                  .read<EventsCalendarCubit>()
                  .withOfCellForGrid(context),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            context
                                .read<EventsCalendarCubit>()
                                .sampleCustomersForGrid[index]
                                .customerName[0]
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: context
                            .read<EventsCalendarCubit>()
                            .sampleCustomersForGrid[index]
                            .customerName,
                        child: Text(
                          context
                              .read<EventsCalendarCubit>()
                              .sampleCustomersForGrid[index]
                              .customerName,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
        itemCount:
            context.read<EventsCalendarCubit>().sampleCustomersForGrid.length,
      ),
    );
  }
}
