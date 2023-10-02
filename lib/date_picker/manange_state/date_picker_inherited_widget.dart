import 'package:flutter/material.dart';

part 'helper_method.dart';

part 'text_theme.dart';

part 'get_date_list_api.dart';

class DatePicker extends InheritedWidget {
  final BuildContext _context;
  final DateTime _currentDate = DateTime.now();
  late DateTime dateOnPageView = _currentDate;
  late final ValueNotifier<DateTime> selectedDateNotifier =
      ValueNotifier(_currentDate);
  late final ValueNotifier<DateTime> dateOnPageViewNotifier =
      ValueNotifier(dateOnPageView);
  final ValueNotifier<bool> pickOnUI = ValueNotifier(true);
  final PageController pageController = PageController();
  final formKey = GlobalKey<FormState>();

  DatePicker(BuildContext context, {super.key, required super.child})
      : _context = context;

  void changeDate(DateTime date) {
    selectedDateNotifier.value = date;
  }

  void dispose() {
    selectedDateNotifier.dispose();
    dateOnPageViewNotifier.dispose();
    pageController.dispose();
  }

  static DatePicker of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DatePicker>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  List<DateTime?> getDataForPageView(int index) {
    dateOnPageView = DateTime(_currentDate.year, _currentDate.month - index);
    return dateListOfMonth(dateTime: dateOnPageView);
  }

  void updateDateOnPageView() {
    dateOnPageViewNotifier.value = dateOnPageView;
  }

  void togglePickOnUI() {
    pickOnUI.value = !pickOnUI.value;
  }
}
