import 'dart:async'; // await
import 'dart:convert'; // JSON.decode & encode

import 'package:flutter/material.dart';
import 'package:buddy_app/screens/feed_screen.dart';
import 'package:buddy_app/screens/calendar_screen.dart';
import 'package:buddy_app/screens/settings_screen.dart';

enum ResultStatus {
  success,
  failure,
  loading,
}

class MainScreen extends StatefulWidget {
  String apiRoot = 'http://api.flutter.institute/'; // http://heyabuddy.com/daily_logs,

  @override
  State createState() => _MainScreenState();
} 

class _MainScreenState extends State<MainScreen> {
  List<String> _items;

  @override
  void initState() {
    _items = List<String>.generate(100, (i) => "Item $i");
  }
  // Future getItem(int id) async {
  //   setState(() {
  //     _status = ResultStatus.loading;
  //   });

  //   try {
  //     // print('${widget.apiRoot}/flutter-json.php?id=$id'); // view via `flutter logs`
  //     final response = await httpClient.get(
  //       '${widget.apiRoot}/flutter-json.php?id=$id',
  //       headers: {HttpHeaders.AUTHORIZATION: "Bearer your_api_token_here"},
  //     );
  //     if (response.statusCode != 200) {
  //       setState(() {
  //         _status = ResultStatus.failure;
  //       });
  //     } else {
  //       final Map data = JSON.decode(response.body);
  //       setState(() {
  //         _status = ResultStatus.success;

  //         final Map<String, dynamic> payload = data['payload'] ?? {};
  //         _name = payload['name'] ?? '<Name Not Found>';
  //         _tags = List<String>.from(payload['tags']) ?? [];
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       print(e);
  //       _status = ResultStatus.failure;
  //     });
  //   };
  // }

  // Future postItem(int id) async {
  //   setState(() {
  //     _status = ResultStatus.loading;
  //   });

  //   try {
  //     final response = await httpClient.post(
  //       '${widget.apiRoot}/flutter-json.php',
  //       body: JSON.encode({'name': 'New Name'}),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     if (response.statusCode != 200) {
  //       setState(() {
  //         _status = ResultStatus.failure;
  //       });
  //     } else {
  //       setState(() {
  //         _status = ResultStatus.success;
  //         _name = _tags = null;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _status = ResultStatus.failure;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: Text('Buddy Tabs Demo'),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: TabBarView(
          children: [
            FeedScreen(items: _items),
            CalendarScreen(items: _items),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }
}
