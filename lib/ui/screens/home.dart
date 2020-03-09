import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:example/core/models/models.dart';
import 'package:example/core/bloc/app_bloc.dart';
import 'package:example/ui/shared/shared.dart';
import 'package:example/ui/widgets/people/people.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with BaseScreenMixin {
  List<People> _peoples = [];
  int _numberItemFavorite = 0;
  StreamSubscription _subscription;
  StreamSubscription _messageSubscription;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onLeftSwipe() {
    _addEventToAppBloc(RemoveFirstPeople());
  }

  void _onRightSwipe() {
    _addEventToAppBloc(RemoveFirstPeople(insertToFavorite: true));
  }

  void _addEventToAppBloc(AppEvent event) {
    BlocProvider.of<AppBloc>(context).add(event);
  }

  void _fetchData() {
    _addEventToAppBloc(InitData(numberItemsDisplay: 3, numberItemsInStock: 6));
  }

  void _showMessage(String message) {
    SnackBar snackBar = SnackBar(
      duration: Duration(milliseconds: 800),
      content: Text('$message'),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _onAppStateChange(AppState state) {
    // Get props state to compare
    List<People> newPeoples = state.peoples;
    int newNumberItemFavorite = state.favorite.length;

    // Condition to re-render
    bool isRerender = false;

    if (_peoples != newPeoples) {
      _peoples = state.peoples.toList();
      isRerender = true;
    }

    if (_numberItemFavorite != newNumberItemFavorite) {
      _numberItemFavorite = newNumberItemFavorite;
      isRerender = true;
    }

    if (isRerender) setState(() {});
  }

  @override
  void afterFirstLayout(BuildContext context) {
    super.afterFirstLayout(context);

    // Fetch data
    _fetchData();

    // Subcribe bloc state
    _subscription = BlocProvider.of<AppBloc>(context).listen(_onAppStateChange);

    // Subcribe message stream and binding to show message
    _messageSubscription =
        BlocProvider.of<AppBloc>(context).message.listen(_showMessage);
  }

  @override
  Widget build(BuildContext context) {
    // Button favorite, navigate to favorite screen
    Widget iconFavorite = Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: IconButtonBadge(
        badgeNumber: _numberItemFavorite,
        icon: Icon(Icons.favorite),
        onPress: () => Navigator.of(context).pushNamed('/favorite'),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Home'), actions: [iconFavorite]),
        body: Center(
            child: PeopleCarousel(
                swipeThreshold: 200 / 2,
                onLeftSwipe: _onLeftSwipe,
                onRightSwipe: _onRightSwipe,
                peoples: _peoples)));
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel all subcription
    _messageSubscription?.cancel();
    _subscription?.cancel();
  }
}
