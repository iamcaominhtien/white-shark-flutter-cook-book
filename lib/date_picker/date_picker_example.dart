import 'package:flutter/material.dart';

import 'date_picker_card.dart';

class DatePickerExample extends StatelessWidget {
  const DatePickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date picker'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show date picker'),
          onPressed: () {
            showMyDatePicker(context);
          },
        ),
      ),
    );
  }
}
