import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Log out'),
          onPressed: () {
            // Navigate to the second screen using a named route
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
    );
  }
}