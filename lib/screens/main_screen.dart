import 'dart:async'; // await
import 'dart:convert'; // JSON.decode & encode

import 'package:flutter/material.dart';

import 'package:buddy_app/screens/feed_screen.dart';
import 'package:buddy_app/screens/calendar_screen.dart';
import 'package:buddy_app/screens/settings_screen.dart';
import 'package:buddy_app/auth.dart';
import 'package:buddy_app/data/database_helper.dart';
import 'package:buddy_app/data/daily_log_ds.dart';
import 'package:buddy_app/models/daily_log.dart';
import 'package:buddy_app/screens/login_screen.dart';

enum ResultStatus {
  success,
  failure,
  loading,
}

class MainScreen extends StatefulWidget {

  @override
  State createState() => _MainScreenState();
} 

class _MainScreenState extends State<MainScreen> implements AuthStateListener {
  List<DailyLog> _dailyLogs = new List();

  DailyLogDatasource dailyLogDatasource = new DailyLogDatasource();

  @override
  void initState() {
    super.initState();
    print('initializing main screen state');
    
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);

    dailyLogDatasource.findAll().then((List<DailyLog> dailyLogs) {
      print('successful findAll');
      print(dailyLogs);
      setState(() {
        _dailyLogs = dailyLogs.reversed.toList();
      });
    }).catchError((Exception error) => print('unsuccessful findAll'));
  }

  void _logout() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    print('_logout');
  }

  @override
  onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_OUT)
      Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new LoginScreen()));
  }

  //   try {
  //     // print('${widget.apiRoot}/flutter-json.php?id=$id');
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
  //     final response = await httpClient.post(
  //       '${widget.apiRoot}/flutter-json.php',
  //       body: JSON.encode({'name': 'New Name'}),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.rss_feed)),
              Tab(icon: Icon(Icons.calendar_today)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          title: Text('Buddy'),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: TabBarView(
          children: [
            FeedScreen(dailyLogs: _dailyLogs),
            CalendarScreen(dailyLogs: _dailyLogs),
            SettingsScreen(logout: () => _logout()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.dispose(this);
    super.dispose();
  }
}
