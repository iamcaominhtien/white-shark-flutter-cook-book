part of 'date_picker_inherited_widget.dart';

extension DateListAPI on DatePicker {
  //start with Sunday and end with Saturday
  List<DateTime?> dateListOfMonth({DateTime? dateTime}) {
    dateTime ??= selectedDateNotifier.value;
    final year = dateTime.year;
    final month = dateTime.month;
    const startDate = 1;
    final endDate = DateTime(year, month + 1, 0).day;
    final startWeek =
        _mapWeekSundayToSaturday(DateTime(year, month, 1).weekday);

    List<DateTime?> results = List.generate(startWeek, (index) => null);
    for (int i = startDate; i <= endDate; i++) {
      results.add(DateTime(year, month, i));
    }

    while (results.length < 42) {
      results.add(null);
    }

    return results;
  }

  int _mapWeekSundayToSaturday(int week) {
    if (week == DateTime.sunday) {
      return 0;
    }
    return week;
  }
}
