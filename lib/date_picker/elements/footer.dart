import 'package:cookbook/date_picker/manange_state/date_picker_inherited_widget.dart';
import 'package:flutter/material.dart';

class FooterDatePicker extends StatelessWidget {
  const FooterDatePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => _cancel(context),
            child: Text(
              'Cancel',
              style: DatePicker.of(context).titleLarge,
            ),
          ),
          TextButton(
            onPressed: () => _ok(context),
            child: Text(
              'Ok',
              style: DatePicker.of(context).titleLarge,
            ),
          )
        ],
      ),
    );
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _ok(BuildContext context) {
    final datePicker = DatePicker.of(context);
    if (!datePicker.pickOnUI.value) {
      //submit form
      datePicker.formKey.currentState?.validate();
    } else {
      Navigator.of(context).pop(datePicker.selectedDateNotifier.value);
    }
  }
}
