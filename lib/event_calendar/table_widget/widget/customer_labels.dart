import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manage_state/event_calender_cubit.dart';

class CustomerLabels extends StatefulWidget {
  const CustomerLabels({
    super.key,
  });

  @override
  State<CustomerLabels> createState() => _CustomerLabelsState();
}

class _CustomerLabelsState extends State<CustomerLabels> {
  late final double withOfCell =
      context.read<EventsCalendarCubit>().withOfCellForTable(context);

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth:
          context.read<EventsCalendarCubit>().sampleCustomersForTable.length <=
                  3
              ? const IntrinsicColumnWidth()
              : const IntrinsicColumnWidth(),
      columnWidths: const {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          children: List.generate(
              context
                      .read<EventsCalendarCubit>()
                      .sampleCustomersForTable
                      .length +
                  1, (index) {
            if (index == 0) {
              return const TableCell(
                  child:
                      SizedBox(width: EventsCalendarCubit.widthOfFirstColumn));
            }
            return TableCell(
              child: SizedBox(
                width: withOfCell,
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
                                  .sampleCustomersForTable[index - 1][0]
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
                              .sampleCustomersForTable[index - 1],
                          child: Text(
                            context
                                .read<EventsCalendarCubit>()
                                .sampleCustomersForTable[index - 1],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
