import 'dart:async';

import 'package:buddy_app/utils/network_util.dart';
import 'package:buddy_app/models/daily_log.dart';
import 'package:buddy_app/data/database_helper.dart';

class DailyLogDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://heyabuddy.com";
  static final DAILY_LOG_URL = BASE_URL + "/daily_logs";
  static final _API_KEY = "somerandomkey";
  DailyLog test = DailyLog(); // todo - delete
  
  Future<String> _authToken() async {
    var db = new DatabaseHelper();
    var token = await db.getAuthToken();
    return token;
  }

  Future<List<DailyLog>> findAll() async {
    var token = await _authToken();
    return _netUtil.get(DAILY_LOG_URL, headers: { "Authorization": "Bearer $token", 'Accept': 'application/vnd.api+json' })
      .then((dynamic res) {
        print('hello from daily_log_ds');
        print(res.toString());
        print(res['error']);

        var data = res['data'];
        // print(data.map((dailyLogJson) => DailyLog.fromJson(dailyLogJson)).toList());
        List<DailyLog> dailyLogs = List<DailyLog>.from(data.map((dailyLogJson) => DailyLog.fromJson(dailyLogJson)));
        print('successful mapping, now returning');
        return dailyLogs;
        // moviesTitles.map((title) => Tab(text: title)).toList()
        
        // return new User.map(res, email);
      });
  }
}