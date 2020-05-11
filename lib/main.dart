import 'package:CWCFlutter/alert_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/alert_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AlertBloc>(
      create: (context) => AlertBloc(),
      child: MaterialApp(
        title: 'Sqflite Tutorial',
        theme: ThemeData(
          primarySwatch: Colors.green,
          canvasColor: Colors.white
//            TODO maybe try to add your own photos as a background
        ),
        home: AlertList(),
      ),
    );
  }
}
