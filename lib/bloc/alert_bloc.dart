import 'package:CWCFlutter/events/add_alert.dart';
import 'package:CWCFlutter/events/delete_alert.dart';
import 'package:CWCFlutter/events/alert_event.dart';
import 'package:CWCFlutter/events/set_alerts.dart';
import 'package:CWCFlutter/events/update_alert.dart';
import 'package:CWCFlutter/model/alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, List<Alert>> {
  @override
  List<Alert> get initialState => List<Alert>();

  @override
  Stream<List<Alert>> mapEventToState(AlertEvent event) async* {
    if (event is SetAlerts) {
      yield event.alertList;
    } else if (event is AddAlert) {
      List<Alert> newState = List.from(state);
      if (event.newAlert != null) {
        newState.add(event.newAlert);
      }
      yield newState;
    } else if (event is DeleteAlert) {
      List<Alert> newState = List.from(state);
      newState.removeAt(event.alertIndex);
      yield newState;
    } else if (event is UpdateAlert) {
      List<Alert> newState = List.from(state);
      newState[event.alertIndex] = event.newAlert;
      yield newState;
    }
  }
}
