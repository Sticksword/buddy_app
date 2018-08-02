import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

import 'package:buddy_app/models/daily_log.dart';

class CalendarScreen extends StatelessWidget {
  final List<DailyLog> dailyLogs;

  CalendarScreen({Key key, @required this.dailyLogs}) : super(key: key);

  void onDateSelected(DateTime date) {
    print('selected a date');
    print(date);
    print('here are the logs passed to calendar screen');
    print(dailyLogs.first);
  }

  @override
  Widget build(BuildContext context) {

    return Calendar(
      isExpandable: true,
      onDateSelected: onDateSelected,
    );
  }
}