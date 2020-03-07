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

  @override
  void afterFirstLayout(BuildContext context) {
    super.afterFirstLayout(context);

    // Fetch data
    _fetchData();

    // Listen state change
    BlocProvider.of<AppBloc>(context).listen(_onAppStateChange);
  }

  @override
  Widget build(BuildContext context) {
    // Button favorite, navigate to favorite screen
    Widget iconFavorite = IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () => Navigator.of(context).pushNamed('/favorite'),
    );

    // Building list people card
    List<Widget> children = _peoples
        .map((people) => PeopleCard(
            address: people.address,
            avatar: people.picture,
            username: people.username,
            password: people.password,
            phone: people.phone,
            cell: people.cell,
            name: people.fullName,
            width: 300,
            height: 350))
        .toList();

    return Scaffold(
        appBar: AppBar(title: Text('Home'), actions: [iconFavorite]),
        body: Center(
            child: Carousel(
                swipeThreshold: 200 / 2,
                onLeftSwipe: _onLeftSwipe,
                onRightSwipe: _onRightSwipe,
                children: children)));
  }

  void _onLeftSwipe() {
    _addEventToAppBloc(RemoveFirstPeople());
  }

  void _onRightSwipe() {
    _addEventToAppBloc(RemoveFirstPeople());
  }

  void _addEventToAppBloc(AppEvent event) {
    BlocProvider.of<AppBloc>(context).add(event);
  }

  void _fetchData() {
    GetPeoples event = GetPeoples(
      amount: 6,
      onSuccess: (peoples) {
        _addEventToAppBloc(AddPeopleToStock(peoples: peoples));
        _addEventToAppBloc(TakePeoplesFromStock(amount: 3));
      },
      onError: (e) {},
    );

    _addEventToAppBloc(event);
  }

  void _onAppStateChange(AppState state) {
    if (_peoples != state.peoples) {
      setState(() {
        _peoples = state.peoples.toList();
      });
    }
  }
}
