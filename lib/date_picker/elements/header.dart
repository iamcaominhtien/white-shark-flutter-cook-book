import 'package:cookbook/date_picker/manange_state/date_picker_inherited_widget.dart';
import 'package:flutter/material.dart';

class HeaderDatePicker extends StatelessWidget {
  const HeaderDatePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select date',
            style: DatePicker.of(context).titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: DatePicker.of(context).selectedDateNotifier,
                  builder: (context, _, child) => Text(
                    // 'Sat, Sep 30',
                    DatePicker.of(context).formatDate(),
                    style: DatePicker.of(context).headlineLarge,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _edit(context),
                icon: ValueListenableBuilder(
                  valueListenable: DatePicker.of(context).pickOnUI,
                  builder: (context, value, child) => Icon(
                    value ? Icons.mode_edit_outlined : Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context) {
    FocusScope.of(context).unfocus();
    DatePicker.of(context).togglePickOnUI();
  }
}
