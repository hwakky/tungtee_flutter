import 'package:flutter/material.dart';

class NewTag extends StatefulWidget {
  final Function addTag;

  NewTag(this.addTag);

  @override
  State<NewTag> createState() => _NewTag();
}

class _NewTag extends State<NewTag> {
  final titleController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;

    if (enteredTitle.isEmpty) {
      return;
    }
    widget.addTag(enteredTitle);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: titleController,
                  onSubmitted: (_) => submitData(),
                ),
                TextButton(
                  child: Text('Add Transaction'),
                  style: TextButton.styleFrom(shadowColor: Colors.green),
                  onPressed: submitData,
                )
              ],
            )));
  }
}
