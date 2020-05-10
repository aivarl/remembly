import 'package:CWCFlutter/model/alert.dart';

import 'alert_event.dart';

class AddAlert extends AlertEvent {
  Alert newAlert;

  AddAlert(Alert alert) {
    newAlert = alert;
  }
}
