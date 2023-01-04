import 'package:flutter/material.dart';
import './models/tag.dart';
import './widgets/new_tag.dart';
import './widgets/tag_list.dart';
import 'package:tangteevs/utils/color.dart';

class tag extends StatefulWidget {
  const tag({super.key});

  @override
  State<tag> createState() => _tagState();
}

class _tagState extends State<tag> {
  final List<Tag> _addTag = [];
  void _addNewTag(String txTitle) {
    final newTag = Tag(title: txTitle);
    setState(() {
      _addTag.add(newTag);
    });
  }

  void _startAddNewTag(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTag(_addNewTag),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tag',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => _startAddNewTag(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _startAddNewTag(context)),
    );
  }
}
