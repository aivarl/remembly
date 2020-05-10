import 'package:CWCFlutter/model/alert.dart';

import 'alert_event.dart';

class SetAlerts extends AlertEvent {
  List<Alert> alertList;

  SetAlerts(List<Alert> alerts) {
    alertList = alerts;
  }
}
