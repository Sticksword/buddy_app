import 'package:flutter/material.dart';

class FeedRoute extends StatelessWidget {
  final List<String> items;

  FeedRoute({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${items[index]}'),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}