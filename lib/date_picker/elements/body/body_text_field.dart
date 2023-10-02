import 'package:cookbook/date_picker/manange_state/date_picker_inherited_widget.dart';
import 'package:flutter/material.dart';

class BodyDatePickerTextField extends StatelessWidget {
  const BodyDatePickerTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Material(
        child: Form(
          key: DatePicker.of(context).formKey,
          child: TextFormField(
            autofocus: true,
            controller: TextEditingController(
              text: formatDate(context),
            ),
            keyboardType: TextInputType.datetime,
            style: DatePicker.of(context).titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize:
                      (DatePicker.of(context).titleLarge?.fontSize ?? 23) - 3,
                ),
            decoration: InputDecoration(
              hintText: 'dd/mm/yyyy',
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              labelText: 'Enter Date',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Invalid format';
              }
              //format: dd/mm/yyyy. check if it is valid date
              final regex = RegExp(r'^\d{2}\/\d{2}\/\d{4}$');
              if (!regex.hasMatch(value)) {
                return 'Invalid format';
              } else {
                Navigator.of(context).pop(value);
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  String formatDate(BuildContext context) {
    final dateTime = DatePicker.of(context).selectedDateNotifier.value;
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }
}
