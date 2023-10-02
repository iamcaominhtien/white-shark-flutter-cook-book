import 'package:cookbook/event_calendar/table_widget/event_calendar_table.dart';
import 'package:cookbook/main.dart';
import 'package:flutter/material.dart';

import 'grid_widget/event_calendar_grid.dart';

class EventCalendarHome extends StatelessWidget {
  const EventCalendarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildButtonNavigator(
            context,
            'Events calendar using Table widget',
            OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) =>
                  EventsCalendarTable(key: ValueKey(orientation)),
            ),
          ),
          buildButtonNavigator(
            context,
            'Events calendar using Grid widget',
            OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) =>
                  EventCalendarGrid(key: ValueKey(orientation)),
            ),
          ),
        ],
      ),
    );
  }
}
