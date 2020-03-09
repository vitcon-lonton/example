import 'package:flutter/material.dart';

class IconButtonBadge extends StatelessWidget {
  final Icon icon;
  final int badgeNumber;
  final Function onPress;

  final TextStyle contentStyle = TextStyle(color: Colors.white, fontSize: 8);

  IconButtonBadge({
    Key key,
    @required this.icon,
    this.badgeNumber,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(icon: icon, onPressed: onPress);

    Widget badgeContent =
        Text('$badgeNumber', style: contentStyle, textAlign: TextAlign.center);

    Widget badge = Positioned(
      right: 11,
      top: 11,
      child: Container(
        padding: EdgeInsets.all(2),
        constraints: BoxConstraints(minWidth: 14, minHeight: 14),
        child: badgeContent,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );

    return Stack(children: [button, badge]);
  }
}
