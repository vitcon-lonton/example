import 'package:flutter/material.dart';

class PeopleAvatar extends StatelessWidget {
  PeopleAvatar({Key key, this.uri}) : super(key: key);

  final String uri;
  final Decoration decoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.black),
    shape: BoxShape.circle,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.all(5),
        decoration: decoration,
        child: Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(uri)))));
  }
}
