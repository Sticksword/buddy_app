import 'package:flutter/material.dart';

import 'package:buddy_app/screens/detail_screen.dart';
import 'package:buddy_app/models/daily_log.dart';

class FeedScreen extends StatefulWidget {
  final List<DailyLog> dailyLogs;

  FeedScreen({Key key, @required this.dailyLogs}) : super(key: key);

  @override
  State createState() => _FeedScreenState();
} 

class _FeedScreenState extends State<FeedScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${widget.dailyLogs[index].text}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(dailyLog: '${widget.dailyLogs[index].text}'),
                ),
              );
            },
          );
        },
        itemCount: widget.dailyLogs.length,
      ),
      decoration: Theme.of(context).platform == TargetPlatform.iOS
        ? BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[200]),
            ),
          )
        : null
    );
  }
}