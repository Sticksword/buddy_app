import 'dart:io'; // HttpOverrides

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:http/http.dart';

import 'routes.dart';

const String _name = "Your Name";
var httpClient = Client();

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

void main() {
  HttpOverrides.global = StethoHttpOverrides();

  runApp(
    MaterialApp(
      title: "Buddy",
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
      routes: routes,
    )
  );
}
