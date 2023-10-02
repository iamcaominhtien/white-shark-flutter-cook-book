import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widget/customer_labels.dart';
import 'widget/event_list.dart';
import 'widget/grid_cells.dart';

class EventsCalendarTable extends StatefulWidget {
  const EventsCalendarTable({super.key});

  @override
  State<EventsCalendarTable> createState() => _EventsCalendarTableState();
}

class _EventsCalendarTableState extends State<EventsCalendarTable> {
  late final ScrollController verticalScrollController;
  late final int hourNow;
  late final double withOfCell =
      context.read<EventsCalendarCubit>().withOfCellForTable(context);

  @override
  void initState() {
    super.initState();
    //what hour now?
    hourNow = DateTime.now().hour;
    verticalScrollController = ScrollController(
      initialScrollOffset: (hourNow + 1) * EventsCalendarCubit.heightOf15M + 90,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomerLabels(),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: verticalScrollController,
                      child: const Stack(
                        children: [GridCells(), EventLists()],
                      ),
                    ),
                    Positioned(
                      left: EventsCalendarCubit.widthOfFirstColumn,
                      right: 0,
                      top: 0,
                      child: Container(
                        // color: Colors.red,
                        height: 5,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey.withOpacity(0.5),
                            Colors.grey.withOpacity(0.1),
                          ],
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
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
}
