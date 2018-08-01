class User {
  int userId;
  String email;
  String authToken;
  User(this.userId, this.email, this.authToken);

  User.map(dynamic obj, String email) {
    this.userId = obj["id"];
    this.authToken = obj["auth_token"];
    this.email = email;
  }

  User.dbMap(dynamic obj) {
    this.userId = obj["id"];
    this.authToken = obj["auth_token"];
    this.email = obj['email'];
  }

  String get username => email;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = userId;
    map["email"] = email;
    map["auth_token"] = authToken;

    return map;
  }
}