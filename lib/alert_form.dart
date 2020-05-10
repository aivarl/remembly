import 'package:CWCFlutter/bloc/alert_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/add_alert.dart';
import 'package:CWCFlutter/events/update_alert.dart';
import 'package:CWCFlutter/model/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _enabled = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
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
      style: TextStyle(fontSize: 28),
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
              SizedBox(height: 16),
              _buildenabled(),
              SizedBox(height: 20),
              widget.alert == null
                  ? RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
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
                        );

                        DatabaseProvider.db.insert(alert).then(
                              (storedAlert) => BlocProvider.of<AlertBloc>(context).add(
                                AddAlert(storedAlert),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
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
                            );

                            DatabaseProvider.db.update(widget.alert).then(
                                  (storedAlert) => BlocProvider.of<AlertBloc>(context).add(
                                    UpdateAlert(widget.alertIndex, alert),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
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
}
