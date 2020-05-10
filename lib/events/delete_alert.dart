import 'alert_event.dart';

class DeleteAlert extends AlertEvent {
  int alertIndex;

  DeleteAlert(int index) {
    alertIndex = index;
  }
}
