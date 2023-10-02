import 'package:cookbook/date_picker/manange_state/date_picker_inherited_widget.dart';
import 'package:flutter/material.dart';

class BodyToolBarDatePicker extends StatefulWidget {
  const BodyToolBarDatePicker({
    super.key,
  });

  @override
  State<BodyToolBarDatePicker> createState() => _BodyToolBarDatePickerState();
}

class _BodyToolBarDatePickerState extends State<BodyToolBarDatePicker> {
  bool canNextMonth = false;
  bool canLastMonth = true;
  late final datePicker = DatePicker.of(context);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 25),
        const _DateOnPageView(),
        const _ArrowDropDown(),
        const Spacer(),
        IconButton(
          onPressed: canLastMonth ? _lastMonth : null,
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton(
          onPressed: canNextMonth ? _nextMonth : null,
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          icon: const Icon(Icons.chevron_right),
        ),
        const SizedBox(width: 5)
      ],
    );
  }

  void _lastMonth() {
    datePicker.pageController
        .nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    )
        .then((value) {
      if (datePicker.pageController.page == 0) {
        canNextMonth = false;
      } else {
        canNextMonth = true;
      }
      setState(() {});
    });
  }

  void _nextMonth() {
    datePicker.pageController
        .previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    )
        .then((value) {
      if (datePicker.pageController.page == 0) {
        canNextMonth = false;
      } else {
        canNextMonth = true;
      }
      setState(() {});
    });
  }
}

class _DateOnPageView extends StatelessWidget {
  const _DateOnPageView();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: DatePicker.of(context).dateOnPageViewNotifier,
      builder: (context, value, child) => Text(
        '${DatePicker.of(context).getFullMonth(value.month)} ${value.year}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
            height: 1.0, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class _ArrowDropDown extends StatelessWidget {
  const _ArrowDropDown();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -1),
      child: Icon(
        Icons.arrow_drop_down,
        size: 25,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
