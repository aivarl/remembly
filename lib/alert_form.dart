import 'dart:typed_data';

import 'package:CWCFlutter/bloc/alert_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/add_alert.dart';
import 'package:CWCFlutter/events/update_alert.dart';
import 'package:CWCFlutter/model/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlertForm extends StatefulWidget {
  final Alert alert;
  final int alertIndex;

  AlertForm({this.alert, this.alertIndex});

  @override
  State<StatefulWidget> createState() {
    return AlertFormState();
  }
}

class AlertFormState extends State<AlertForm> {
  String _name;
  String _description;

  //TODO think of default values that make sense.
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _enabled = true;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      initialValue: _description,
      decoration: InputDecoration(labelText: 'Description'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        int description = int.tryParse(value);
//        if (description == null || description <= 0) {
//          return 'Calories must be greater than 0';
//        }
        return null;
      },
      onSaved: (String value) {
        _description = value;
      },
    );
  }

  Widget _buildStartTime() {
    return ListTile(
      title: Text("Start: ${_startTime.hour}:${_startTime.minute}"),
      trailing: Icon(Icons.keyboard_arrow_down),
      onTap: _pickStartTime,
    );
  }

  _pickStartTime() async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: _startTime);
    if (t != null)
      setState(() {
        _startTime = t;
      });
  }

  Widget _buildEndTime() {
    return ListTile(
      title: Text("End: ${_endTime.hour}:${_endTime.minute}"),
      trailing: Icon(Icons.keyboard_arrow_down),
      onTap: _pickEndTime,
    );
  }

  //TODO should be possible to reuse this function, but gave an error - maybe examine later
  _pickEndTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: _endTime);
    if (t != null)
      setState(() {
        _endTime = t;
      });
  }

  Widget _buildenabled() {
    return SwitchListTile(
      title: Text("Enabled?", style: TextStyle(fontSize: 20)),
      value: _enabled,
      onChanged: (bool newValue) => setState(() {
        _enabled = newValue;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.alert != null) {
      _name = widget.alert.name;
      _description = widget.alert.description;
      _enabled = widget.alert.enabled;
      _startTime = widget.alert.startTime;
      _endTime = widget.alert.endTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alert Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildDescription(),
              _buildStartTime(),
              _buildEndTime(),
              SizedBox(height: 14),
              _buildenabled(),
              SizedBox(height: 20),
              widget.alert == null
                  ? RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        Alert alert = Alert(
                          name: _name,
                          description: _description,
                          enabled: _enabled,
                          startTime: _startTime,
                          endTime: _endTime,
                        );

                        DatabaseProvider.db.insert(alert).then(
                              (storedAlert) =>
                                  BlocProvider.of<AlertBloc>(context).add(
                                AddAlert(storedAlert),
                              ),
                            );
                        //TODO I guess here I should schedule the notification
                        _periodicallyShow();

                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 14),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState.save();

                            Alert alert = Alert(
                              name: _name,
                              description: _description,
                              enabled: _enabled,
                              startTime: _startTime,
                              endTime: _endTime,
                            );

                            DatabaseProvider.db.update(widget.alert).then(
                                  (storedAlert) =>
                                      BlocProvider.of<AlertBloc>(context).add(
                                    UpdateAlert(widget.alertIndex, alert),
                                  ),
                                );
                            //TODO I guess here I should schedule the notification
//                            _scheduleNotification();
                            _periodicallyShow();

                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO params for laters
  Future _scheduleNotification() async {
    var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: 5));
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'secondary_icon',
//        sound: 'slow_spring_board',
//        largeIcon: 'sample_large_icon',
//        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        color: const Color.fromARGB(255, 255, 0, 0));
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
//  Future<void> periodicallyShow(int id, String title, String body,
//      RepeatInterval repeatInterval, NotificationDetails notificationDetails,
//      {String payload}) async {
    Future<void> _periodicallyShow() async {
      var time = Time(20, 49, 0);
      var androidPlatformChannelSpecifics =
      AndroidNotificationDetails('repeatDailyAtTime channel id',
          'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
      var iOSPlatformChannelSpecifics =
      IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          'show daily title',
          'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
          time,
          platformChannelSpecifics);
    }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

    Future<void> _showNotification() async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'plain title', 'helllo good sir', platformChannelSpecifics,
          payload: 'item x');
    }
}
