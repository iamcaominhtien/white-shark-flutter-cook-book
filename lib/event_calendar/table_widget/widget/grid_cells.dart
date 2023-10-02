import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:cookbook/event_calendar/table_widget/widget/row_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridCells extends StatefulWidget {
  const GridCells({
    super.key,
  });

  @override
  State<GridCells> createState() => _GridCellsState();
}

class _GridCellsState extends State<GridCells> {
  late final double withOfCell =
      context.read<EventsCalendarCubit>().withOfCellForTable(context);

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      columnWidths: const {
        0: IntrinsicColumnWidth(),
      },
      children: List.generate(
        24,
        (indexRow) => TableRow(
          children: List.generate(
              context
                      .read<EventsCalendarCubit>()
                      .sampleCustomersForTable
                      .length +
                  1, (indexCol) {
            if (indexCol == 0) {
              return RowLabel(indexRow: indexRow);
            }
            return TableCell(
              child: SizedBox(
                width: withOfCell,
                height: EventsCalendarCubit.heightOf15M * 4,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      clipBehavior: Clip.none,
                      decoration: BoxDecoration(
                        border: Border(
                          right: const BorderSide(color: Colors.grey),
                          bottom: const BorderSide(color: Colors.grey),
                          left: indexCol == 1
                              ? const BorderSide(color: Colors.grey)
                              : BorderSide.none,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment:
                        //     MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.5)),
                              )),
                              child: InkWell(
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
