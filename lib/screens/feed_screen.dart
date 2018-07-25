import 'package:flutter/material.dart';

import 'package:buddy_app/screens/detail_screen.dart';

class FeedScreen extends StatefulWidget {
  final List<String> items;

  FeedScreen({Key key, @required this.items}) : super(key: key);

  @override
  State createState() => _FeedScreenState();
} 

class _FeedScreenState extends State<FeedScreen> {
  
  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${widget.items[index]}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: '${widget.items[index]}'),
                ),
              );
            },
          );
        },
        itemCount: widget.items.length,
      ),
      decoration: Theme.of(context).platform == TargetPlatform.iOS
        ? BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[200]),
            ),
          )
        : null
    );
  }
}