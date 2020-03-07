import 'package:flutter/material.dart';

class PeopleActions extends StatelessWidget {
  final List<IconData> icons;
  final List<Function> actions;
  final int activeIndex;

  final Color iconColor = Color(0xffd8d3d2);
  final Color iconColorActive = Colors.green[300];
  final double iconSize = 28;

  PeopleActions({
    Key key,
    @required this.icons,
    @required this.actions,
    this.activeIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons
                .asMap()
                .entries
                .map((entrie) => IconButton(
                    onPressed: actions[entrie.key],
                    icon: Icon(
                      icons[entrie.key],
                      size: iconSize,
                      color: activeIndex == entrie.key
                          ? iconColorActive
                          : iconColor,
                    )))
                .toList()));
  }
}
