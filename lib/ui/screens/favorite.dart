import 'package:example/core/bloc/app_bloc.dart';
import 'package:example/core/models/models.dart';
import 'package:example/ui/shared/shared.dart';
import 'package:example/ui/widgets/people/people.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with BaseScreenMixin {
  List<People> _favorite = [];

  @override
  void afterFirstLayout(BuildContext context) {
    super.afterFirstLayout(context);

    // Listen state change
    BlocProvider.of<AppBloc>(context).listen(_onStateChange);
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

  void _onStateChange(AppState state) {
    if (_favorite != state.favorite) {
      setState(() {
        _favorite = state.favorite.toList();
      });
    }
  }
}
