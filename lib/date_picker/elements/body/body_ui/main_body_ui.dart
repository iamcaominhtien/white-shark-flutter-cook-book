import 'package:cookbook/date_picker/manange_state/date_picker_inherited_widget.dart';
import 'package:cookbook/date_picker/widgets/date_button.dart';
import 'package:flutter/material.dart';

class MainBodyDatePickerUI extends StatefulWidget {
  const MainBodyDatePickerUI({
    super.key,
  });

  @override
  State<MainBodyDatePickerUI> createState() => _MainBodyDatePickerUIState();
}

class _MainBodyDatePickerUIState extends State<MainBodyDatePickerUI> {
  static const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const aspectRatio = 1.1;
  static const paddingLeft = 4.0;
  static const paddingRight = 8.0;
  static const paddingBottom = 7.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AspectRatio(
        aspectRatio: containerAspectRatio(constraints.maxWidth),
        child: PageView.builder(
          reverse: true,
          controller: DatePicker.of(context).pageController,
          onPageChanged: (value) {
            DatePicker.of(context).updateDateOnPageView();
          },
          itemBuilder: (context, index) {
            final dateList = DatePicker.of(context).getDataForPageView(index);
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: paddingBottom,
                  left: paddingLeft,
                  right: paddingRight),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: ValueListenableBuilder(
                  valueListenable: DatePicker.of(context).selectedDateNotifier,
                  builder: (context, value, _) => GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      if (index < 7) {
                        return Center(
                          child: Text(
                            weekdays[index],
                            style: DatePicker.of(context).titleMedium,
                          ),
                        );
                      }
                      return DateButton(dateList[index - 7]);
                    },
                    itemCount: 49,
                  ),
                ),
              ),
            );
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  double containerAspectRatio(double width) {
    return (width + paddingLeft + paddingRight) /
        (width / aspectRatio + paddingBottom);
  }
}
