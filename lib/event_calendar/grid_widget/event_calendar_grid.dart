import 'package:cookbook/event_calendar/grid_widget/widget/cells_grid.dart';
import 'package:cookbook/event_calendar/grid_widget/widget/customers_tasks.dart';
import 'package:cookbook/event_calendar/grid_widget/widget/labels_col.dart';
import 'package:cookbook/event_calendar/grid_widget/widget/labels_row.dart';
import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCalendarGrid extends StatefulWidget {
  const EventCalendarGrid({super.key});

  @override
  State<EventCalendarGrid> createState() => _EventCalendarGridState();
}

class _EventCalendarGridState extends State<EventCalendarGrid> {
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  final _rowLabels = const RowLabels();

  final _horizontalScrollOffsetValueNotifier = ValueNotifier<double>(0);
  final _verticalScrollOffsetValueNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _horizontalScrollController.addListener(horizontalScrollListener);
    _verticalScrollController.addListener(verticalScrollListener);
  }

  @override
  void dispose() {
    _horizontalScrollController.removeListener(horizontalScrollListener);
    _verticalScrollController.removeListener(verticalScrollListener);
    _horizontalScrollOffsetValueNotifier.dispose();
    _verticalScrollOffsetValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalScrollController,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _verticalScrollController,
                    child: Stack(
                      children: [
                        const CellsGrid(),
                        const Positioned.fill(
                          top: EventsCalendarCubit.heightOf15M * 4,
                          child: CustomersTasks(),
                        ),
                        Positioned(
                          top: EventsCalendarCubit.heightOf15M * 4,
                          left: EventsCalendarCubit.widthOfFirstColumn,
                          right: 0,
                          child: ValueListenableBuilder(
                            valueListenable: _verticalScrollOffsetValueNotifier,
                            builder: (context, value, child) =>
                                Transform.translate(
                              offset: Offset(0, value),
                              child: child,
                            ),
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey,
                                    Colors.grey.withOpacity(0.2),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: EventsCalendarCubit.heightOf15M * 4,
                          child: ValueListenableBuilder(
                            valueListenable:
                                _horizontalScrollOffsetValueNotifier,
                            builder: (BuildContext context, double value,
                                Widget? child) {
                              return Transform.translate(
                                offset: Offset(value, 0),
                                child: child,
                              );
                            },
                            child: _rowLabels,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    child: LabelsColumn(),
                  ),
                ],
              ),
            ),
            // rowLabels,
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
              elevation: 2,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Icon(Icons.calendar_month_sharp, size: 35),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Icon(Icons.add, size: 35),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  int get numberOfCol =>
      context.read<EventsCalendarCubit>().sampleCustomersForGrid.length + 1;

  void horizontalScrollListener() {
    _horizontalScrollOffsetValueNotifier.value =
        _horizontalScrollController.offset;
  }

  void verticalScrollListener() {
    _verticalScrollOffsetValueNotifier.value = _verticalScrollController.offset;
  }
}
