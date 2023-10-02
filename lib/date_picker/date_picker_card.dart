import 'dart:math';

import 'package:flutter/material.dart';

import 'elements/body/body_text_field.dart';
import 'manange_state/date_picker_inherited_widget.dart';
import 'elements/body/body_ui/body_ui.dart';
import 'elements/footer.dart';
import 'elements/header.dart';

Future<T?> showMyDatePicker<T>(BuildContext context) {
  return showDialog<T>(
    context: context,
    builder: (context) => const DatePickerContainer(),
  );
}

class DatePickerContainer extends StatefulWidget {
  const DatePickerContainer({super.key});

  @override
  State<DatePickerContainer> createState() => _DatePickerContainerState();
}

class _DatePickerContainerState extends State<DatePickerContainer> {
  late final DatePicker datePicker;

  @override
  void initState() {
    super.initState();
    datePicker = DatePicker(context, child: const DatePickerCard());
  }

  @override
  Widget build(BuildContext context) {
    return datePicker;
  }

  @override
  void dispose() {
    datePicker.dispose();
    super.dispose();
  }
}

class DatePickerCard extends StatelessWidget {
  const DatePickerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: min(400, MediaQuery.of(context).size.width * 0.85),
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderDatePicker(),
            const Divider(),
            // BodyDatePickerUI(),
            ValueListenableBuilder(
              valueListenable: DatePicker.of(context).pickOnUI,
              builder: (context, value, child) => value
                  ? const BodyDatePickerUI()
                  : const BodyDatePickerTextField(),
            ),
            const Flexible(child: FooterDatePicker()),
          ],
        ),
      ),
    );
  }
}
