import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:example/core/models/models.dart';
import 'package:example/core/repositories/reposotories.dart';
import 'package:example/ui/shared/shared.dart';
import 'package:example/ui/widgets/people/people.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PeopleRepository _repository = new PeopleRepository();

  List<People> _peoplesStock = [];
  List<People> _peoples = [];

  Future _getPeoples({
    int amount,
    Function(List<People>) onSuccess,
    Function onError,
  }) {
    return _repository
        .getRandomPeoples(amount: amount)
        .then(onSuccess)
        .catchError(onError);
  }

  void _takePeoplesFromStock({int amount = 1}) {
    List<People> peoples = _peoplesStock.getRange(0, amount - 1).toList();
    _peoplesStock.removeRange(0, amount - 1);
    _peoples.addAll(peoples);

    setState(() {});
  }

  void _addPeopleToStock(List<People> peoples) {
    _peoplesStock.addAll(peoples);
  }

  void _onLeftSwipe() {
    _removeLastPeople();
  }

  void _onRightSwipe() {
    _removeLastPeople();
  }

  void _onError(dynamic e) {}

  void _removeLastPeople() {
    _getPeoples(
      amount: 1,
      onSuccess: _addPeopleToStock,
      onError: _onError,
    );

    if (_peoplesStock.isNotEmpty) {
      People people = _peoplesStock.removeAt(0);

      _peoples.add(people);
    }

    _peoples.removeAt(0);

    setState(() {});
  }

  Widget _buildCard(People people) => PeopleCard(
        address: people.address,
        avatar: people.picture,
        username: people.username,
        password: people.password,
        phone: people.phone,
        cell: people.cell,
        name: people.fullName,
        width: 300,
        height: 350,
      );

  @override
  void initState() {
    super.initState();

    _getPeoples(
      amount: 6,
      onSuccess: (peoples) {
        _addPeopleToStock(peoples);
        _takePeoplesFromStock(amount: 3);
      },
      onError: _onError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: Carousel(
              children: _peoples.map((_buildCard)).toList(),
              swipeThreshold: 200 / 2,
              onLeftSwipe: _onLeftSwipe,
              onRightSwipe: _onRightSwipe),
        ));
  }
}
