import 'dart:async';

import 'package:buddy_app/utils/network_util.dart';
import 'package:buddy_app/models/user.dart';

class UserDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://heyabuddy.com";
  static final LOGIN_URL = BASE_URL + "/authenticate";
  static final _API_KEY = "somerandomkey";

  Future<User> login(String email, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "email": email,
      "password": password
    }).then((dynamic res) {
      print('hello from user_ds');
      print(res.toString());
      print(res['error']);

      print('hello');
      return new User.map(res, email);
    });
  }
}