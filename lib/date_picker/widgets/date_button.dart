import 'package:cookbook/date_picker/manange_state/date_picker_inherited_widget.dart';
import 'package:flutter/material.dart';

class DateButton extends StatelessWidget {
  const DateButton(this.dateTime, {super.key});

  final DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    final enable = dateTime != null;
    final selected = enable &&
        DatePicker.of(context).compareDateTime(
            DatePicker.of(context).selectedDateNotifier.value, dateTime!);

    return Align(
      child: IconButton(
        onPressed: enable ? () => onPressed(context) : null,
        style: IconButton.styleFrom(
          backgroundColor:
              selected ? Theme.of(context).colorScheme.primary : null,
          shape: const CircleBorder(),
        ),
        icon: Text(
          dateTime?.day.toString() ?? '',
          style: DatePicker.of(context).titleMedium?.copyWith(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }

  void onPressed(BuildContext context) {
    DatePicker.of(context).changeDate(dateTime!);
  }
}
