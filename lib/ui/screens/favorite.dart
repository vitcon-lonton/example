import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:example/core/bloc/app_bloc.dart';
import 'package:example/core/models/models.dart';
import 'package:example/ui/shared/shared.dart';
import 'package:example/ui/widgets/people/people.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with BaseScreenMixin {
  List<People> _favorite = [];
  StreamSubscription _subscription;

  void _onStateChange(AppState state) {
    if (_favorite != state.favorite) {
      setState(() {
        _favorite = state.favorite.toList();
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    super.afterFirstLayout(context);

    // Subcribe bloc state
    _subscription = BlocProvider.of<AppBloc>(context).listen(_onStateChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Favorite')),
        body: ListView(
            children: _favorite
                .map(
                  (people) => PeopleCard(
                    address: people.address,
                    avatar: people.picture,
                    username: people.username,
                    password: people.password,
                    phone: people.phone,
                    cell: people.cell,
                    name: people.fullName,
                    width: 300,
                    height: 350,
                  ),
                )
                .toList()));
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel subcription
    _subscription?.cancel();
  }
}
