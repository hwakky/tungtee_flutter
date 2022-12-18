import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _activityName;
  late String _place;
  late String _location;
  late DateTime _date;
  late TimeOfDay _time;
  late String _detail;
  late int _peopleLimit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Activity Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid activity name';
                }
                return null;
              },
              onSaved: (value) => _activityName = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Place'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid place';
                }
                return null;
              },
              onSaved: (value) => _place = value!,
            ),
            // Add a Google Maps widget to select the location
            // ...
            TextFormField(
              decoration: InputDecoration(labelText: 'Date'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid date';
                }
                return null;
              },
              onSaved: (value) => _date = DateTime.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Time'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid time';
                }
                return null;
              },
              onSaved: (value) =>
                  _time = TimeOfDay.fromDateTime(DateTime.parse(value!)),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Detail'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid detail';
                }
                return null;
              },
              onSaved: (value) => _detail = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'People Limit'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid people limit';
                }
                return null;
              },
              onSaved: (value) => _peopleLimit = value! as int,
            ),
          ],
        ),
      ),
    );
  }
}
