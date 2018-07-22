import 'dart:async'; // await
import 'dart:convert'; // JSON.decode & encode
import 'dart:io'; // HttpOverrides

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:http/http.dart';

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
      initialRoute: '/',
      routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
        '/': (context) => FirstScreen(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
        '/second': (context) => ChatScreen(apiRoot: 'http://api.flutter.institute/'), // http://heyabuddy.com/daily_logs,
      },
    )
  );
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, this.apiRoot}) : super(key: key);

  final String apiRoot;

  @override
  State createState() => _ChatScreenState();
} 

enum ResultStatus {
  success,
  failure,
  loading,
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  ResultStatus _status;
  String _name;
  List<String> _tags;

  @override
  void initState() {
    _status = null;
    _tags = [];
  }

  Future getItem(int id) async {
    setState(() {
      _status = ResultStatus.loading;
    });

    try {
      // print('${widget.apiRoot}/flutter-json.php?id=$id'); // view via `flutter logs`
      final response = await httpClient.get(
        '${widget.apiRoot}/flutter-json.php?id=$id',
        headers: {HttpHeaders.AUTHORIZATION: "Bearer your_api_token_here"},
      );
      if (response.statusCode != 200) {
        setState(() {
          _status = ResultStatus.failure;
        });
      } else {
        final Map data = JSON.decode(response.body);
        setState(() {
          _status = ResultStatus.success;

          final Map<String, dynamic> payload = data['payload'] ?? {};
          _name = payload['name'] ?? '<Name Not Found>';
          _tags = List<String>.from(payload['tags']) ?? [];
        });
      }
    } catch (e) {
      setState(() {
        print(e);
        _status = ResultStatus.failure;
      });
    };
  }

  Future postItem(int id) async {
    setState(() {
      _status = ResultStatus.loading;
    });

    try {
      final response = await httpClient.post(
        '${widget.apiRoot}/flutter-json.php',
        body: JSON.encode({'name': 'New Name'}),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        setState(() {
          _status = ResultStatus.failure;
        });
      } else {
        setState(() {
          _status = ResultStatus.success;
          _name = _tags = null;
        });
      }
    } catch (e) {
      setState(() {
        _status = ResultStatus.failure;
      });
    }
  }

  void _handleSubmitted(String text) {
    if (!_isComposing) {
      return;
    }
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: Duration(milliseconds: 1000),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ?
                CupertinoButton(
                  child: Text("Send"),
                  onPressed: _isComposing ? () =>  _handleSubmitted(_textController.text) : null,
                ) :
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isComposing ? () =>  _handleSubmitted(_textController.text) : null,
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAPIContent(BuildContext context) {
    if (_status != null) {
      switch (_status) {
        case ResultStatus.success:
          final List<Widget> children = [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Result: '),
                Text(
                  'success',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ];

          if (_name?.isNotEmpty == true) {
            children.add(Text('Name: $_name'));

            if (_tags?.isNotEmpty == true) {
              children.add(Text('Tags: ${_tags.join(', ')}'));
            }
          }

          return Column(
            children: children,
          );

        case ResultStatus.failure:
          return Center(
            child: Text(
              'Request Failed',
              style: TextStyle(color: Colors.red),
            ),
          );

        case ResultStatus.loading:
          return Center(
            child: Text('Making API Request'),
          );
      }
    }

    return Container();
  }

  void onDateSelected(DateTime date) {
    print(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buddy"),
        elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
            Divider(height: 5.0),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: Text('Get Item 1'),
                  onPressed: () => getItem(0),
                ),
                MaterialButton(
                  child: Text('Get Item 2'),
                  onPressed: () => getItem(1),
                ),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: Text('Get Bad Item'),
                  onPressed: () => getItem(100),
                ),
                MaterialButton(
                  child: Text('Post Item 1'),
                  onPressed: () => postItem(0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            buildAPIContent(context),
            Calendar(
              isExpandable: true,
              onDateSelected: onDateSelected,
            ),
            RaisedButton(
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                // off the stack
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                ),
              )
            : null
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

// example usage - Post.fromJson(responseJson);
// see more - https://flutter.io/cookbook/networking/authenticated-requests/
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}