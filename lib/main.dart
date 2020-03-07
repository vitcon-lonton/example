import 'package:example/core/bloc/app_bloc.dart';
import 'package:flutter/material.dart';

import 'package:example/ui/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppBloc _appBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => _appBloc = AppBloc(),
        child: MaterialApp(
            initialRoute: '/',
            title: 'Flutter Demo',
            theme: ThemeData(primarySwatch: Colors.blue),
            routes: {
              '/': (context) => HomeScreen(),
              '/favorite': (context) => FavoriteScreen()
            }));
  }

  @override
  void dispose() {
    super.dispose();
    _appBloc?.close();
  }
}
