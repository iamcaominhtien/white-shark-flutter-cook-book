import 'package:cookbook/event_calendar/events_model.dart';
import 'package:cookbook/event_calendar/manage_state/event_calender_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerTimesBlocks extends StatelessWidget {
  const CustomerTimesBlocks(
    this.event, {
    super.key,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.read<EventsCalendarCubit>().withOfCellForGrid(context),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        reverse: true,
        itemBuilder: (context, hour) => const _Block(),
        itemCount: 24,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: context.read<EventsCalendarCubit>().withOfCellForGrid(context),
          height: EventsCalendarCubit.heightOf15M * 4,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1.0),
              left: BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              4,
              (index) => _Cell(index, _onTap),
            ),
          ),
        ),
      ],
    );
  }

  void _onTap() {
    print('tapped');
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.index, this.onTap);

  final int index;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: index < 3
                ? const BorderSide(color: Colors.grey, width: 0.5)
                : BorderSide.none,
          ),
        ),
        child: InkWell(onTap: onTap),
      ),
    );
  }
}
