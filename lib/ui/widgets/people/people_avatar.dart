import 'package:cached_network_image/cached_network_image.dart';
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
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
                imageUrl: uri,
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => CircularProgressIndicator(),
                imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill))))));
  }
}
