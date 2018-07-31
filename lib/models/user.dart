class User {
  int _user_id;
  String _username;
  String _auth_token;
  User(this._username);

  User.map(dynamic obj, String username) {
    this._user_id = obj["id"];
    this._auth_token = obj["auth_token"];
  }

  String get username => _username;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _user_id;
    map["username"] = _username;

    return map;
  }
}