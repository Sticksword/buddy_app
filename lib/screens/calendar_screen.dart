import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class CalendarScreen extends StatelessWidget {
  final List<String> items;

  CalendarScreen({Key key, @required this.items}) : super(key: key);

  void onDateSelected(DateTime date) {
    print(date);
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

    return Calendar(
      isExpandable: true,
      onDateSelected: onDateSelected,
    );
  }
}