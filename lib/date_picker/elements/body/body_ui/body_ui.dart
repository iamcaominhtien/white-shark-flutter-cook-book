import 'package:flutter/material.dart';

import 'body_tool_bar_ui.dart';
import 'main_body_ui.dart';

class BodyDatePickerUI extends StatelessWidget {
  const BodyDatePickerUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BodyToolBarDatePicker(),
        MainBodyDatePickerUI(),
      ],
    );
  }
}
