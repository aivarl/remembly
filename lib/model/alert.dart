import 'package:CWCFlutter/db/database_provider.dart';

class Alert {
  int id;
  String name;
  String description;
  bool enabled;

  Alert({this.id, this.name, this.description, this.enabled});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_DESCRIPTION: description,
      DatabaseProvider.COLUMN_Enabled: enabled ? 1 : 0
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
    enabled = map[DatabaseProvider.COLUMN_Enabled] == 1;
  }
}
