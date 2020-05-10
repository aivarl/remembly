import 'package:CWCFlutter/model/alert.dart';

import 'alert_event.dart';

class UpdateAlert extends AlertEvent {
  Alert newAlert;
  int alertIndex;

  UpdateAlert(int index, Alert alert) {
    newAlert = alert;
    alertIndex = index;
  }
}
