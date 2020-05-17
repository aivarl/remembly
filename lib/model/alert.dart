import 'package:CWCFlutter/db/database_provider.dart';
import 'package:flutter/material.dart';

class Alert {
  int id;
  String name;
  String description;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool enabled;
  int interval;

  Alert({this.id, this.name, this.description, this.enabled, this.startTime, this.endTime, this.interval});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_DESCRIPTION: description,
      DatabaseProvider.COLUMN_ENABLED: enabled ? 1 : 0,
      DatabaseProvider.COLUMN_START_TIME: startTime.hour.toString() + ':' + startTime.minute.toString(),
      DatabaseProvider.COLUMN_END_TIME: endTime.hour.toString() + ':' + endTime.minute.toString(),
      DatabaseProvider.COLUMN_INTERVAL: interval
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Alert.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    description = map[DatabaseProvider.COLUMN_DESCRIPTION];
    enabled = map[DatabaseProvider.COLUMN_ENABLED] == 1;
    startTime = timeOfDayFromString(map[DatabaseProvider.COLUMN_START_TIME]);
    endTime = timeOfDayFromString(map[DatabaseProvider.COLUMN_END_TIME]);
    interval = map[DatabaseProvider.COLUMN_INTERVAL];
  }

  TimeOfDay timeOfDayFromString(String str) {
    List<String> parts = str.split(':');
    return new TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
