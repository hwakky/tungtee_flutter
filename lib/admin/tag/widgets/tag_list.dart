import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tag.dart';

class TagList extends StatelessWidget {
  final List<Tag> tag;

  TagList(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: tag.isEmpty
            ? Column(
                children: <Widget>[
                  Text(
                    'No tag added yet!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/yduck.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('\$${tag[index]}.amount}'),
                          ),
                        ),
                      ),
                      title: Text(tag[index].title,
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                  );
                },
                itemCount: tag.length,
              ));
  }
}
