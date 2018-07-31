import 'dart:ui'; // ImageFilter
import 'package:flutter/material.dart';

import 'package:buddy_app/data/user_ds.dart';
import 'package:buddy_app/models/user.dart';
import 'package:buddy_app/auth.dart';
import 'package:buddy_app/data/database_helper.dart';
import 'package:buddy_app/screens/main_screen.dart';

// inspiration - https://medium.com/@kashifmin/flutter-login-app-using-rest-api-and-sqflite-b4815aed2149
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> implements AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;
  UserDatasource api = new UserDatasource();

  LoginScreenState() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      _onLoginSuccess(user);
    }).catchError((Exception error) => _onLoginError(error.toString()));
  }

  void _onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  void _onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

  @override
  onAuthStateChanged(AuthState state) {
    print('login screen onAuthStateChanged');
    print(_ctx);
    print(context);

    if(state == AuthState.LOGGED_IN)
      Navigator.pushReplacement(
      _ctx,
      new MaterialPageRoute(
          builder: (BuildContext context) => new MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    print('building login screen');
    print(_ctx);
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );
    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "HeyaBuddy",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 10
                        ? "Email must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Email"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
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