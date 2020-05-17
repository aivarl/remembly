import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/delete_alert.dart';
import 'package:CWCFlutter/events/set_alerts.dart';
import 'package:CWCFlutter/alert_form.dart';
import 'package:CWCFlutter/model/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/alert_bloc.dart';

class AlertList extends StatefulWidget {
  const AlertList({Key key}) : super(key: key);

  @override
  _AlertListState createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getAlerts().then(
      (alertList) {
        BlocProvider.of<AlertBloc>(context).add(SetAlerts(alertList));
      },
    );
  }

  showAlertDialog(BuildContext context, Alert alert, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.name),
        content: Text("ID ${alert.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AlertForm(alert: alert, alertIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(alert.id).then((_) {
              BlocProvider.of<AlertBloc>(context).add(
                DeleteAlert(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire alert list scaffold");
    return Scaffold(
      //appBar: AppBar(title: Text("remembly")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(24),

          child:BlocConsumer<AlertBloc, List<Alert>>(
          builder: (context, alertList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("alertList: $alertList");

                Alert alert = alertList[index];
                return Card(
                  color: Colors.white70,
                  child: InkWell(
                    splashColor: Colors.blue,
                    child: ListTile(
                    title: Text(alert.name, style: TextStyle(fontSize: 25)),
                    subtitle: Text(
                      "${alert.description}\nRepeat interval:\nEnabled: ${alert.enabled}",
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: Text("${timeStr(alert.startTime)} - ${timeStr(alert.endTime)}"),
                    onTap: () => showAlertDialog(context, alert, index))));
              },
              itemCount: alertList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.transparent),
            );
          },
          listener: (BuildContext context, alertList) {},
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "back",
              onPressed: () {},
              child: Icon(Icons.navigate_before),
            ),
            FloatingActionButton(
              heroTag: "alertForm",
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => AlertForm()),
              ),
            ),
          ],
        ),
      )
      ,
    );
  }

  String timeStr(TimeOfDay tod) {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10)
        return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(tod.hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(tod.minute);

    return '$hourLabel:$minuteLabel';
  }

}
