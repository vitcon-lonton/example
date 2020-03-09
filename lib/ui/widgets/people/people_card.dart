import 'package:flutter/material.dart';

import 'people_avatar.dart';
import 'people_actions.dart';

class PeopleCard extends StatefulWidget {
  PeopleCard({
    Key key,
    this.address,
    this.avatar,
    this.width,
    this.height,
    this.username,
    this.password,
    this.picture,
    this.phone,
    this.cell,
    this.name,
    this.initActiveIndex = 0,
    this.onActiveIndexChange,
  }) : super(key: key);

  /// Props
  final double width;
  final double height;
  final String address;
  final String avatar;
  final String username;
  final String password;
  final String picture;
  final String phone;
  final String cell;
  final String name;
  final int initActiveIndex;
  final Function(int) onActiveIndexChange;

  /// Default data, icons action, style text
  ///
  final List<IconData> icons = [
    Icons.person_outline,
    Icons.map,
    Icons.phone,
    Icons.lock
  ];
  final List<String> titles = [
    "My infomation is",
    "My address is",
    "My phone number is",
    "My password is",
  ];
  final Color iconColor = Color(0xffd8d3d2);
  final double iconSize = 28;
  final TextStyle titleStyle = TextStyle(fontSize: 18, color: Colors.grey[600]);

  @override
  _PeopleCardState createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
  /// [Integer] from 0 to icons length - 1(widget.icons),
  /// Now in this use case, my icons length = 4
  int activeIndex;
  Function changeActiveAction(i) => () {
        setState(() {
          if (widget.onActiveIndexChange != null) widget.onActiveIndexChange(i);
          activeIndex = i;
        });
      };

  @override
  void initState() {
    super.initState();

    // Init active index
    activeIndex = widget.initActiveIndex;
  }

  @override
  Widget build(BuildContext context) {
    // Build avatar for people
    PeopleAvatar avatar = PeopleAvatar(uri: widget?.avatar ?? "");

    // Build actions button for people
    PeopleActions peopleActions = PeopleActions(
      icons: widget.icons,
      activeIndex: activeIndex,
      actions: widget.icons
          .asMap()
          .entries
          .map((entry) => changeActiveAction(entry.key))
          .toList(),
    );

    // Build title active for card
    Widget title = Text(widget.titles[activeIndex], style: widget.titleStyle);

    // Build content active for card
    String contentText = "";

    if (activeIndex == 0)
      contentText = widget.name;
    else if (activeIndex == 1)
      contentText = widget.address;
    else if (activeIndex == 2)
      contentText = widget.phone;
    else
      contentText = widget.password;

    Widget content = Text(
      contentText,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 25),
    );

    return Material(
        child: Card(
            child: Container(
                width: widget.width,
                height: widget.height,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      border: Border(
                                          bottom: BorderSide(
                                              color: widget.iconColor))))),
                          Flexible(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Title
                                        title,
                                        SizedBox(height: 5),

                                        // Content
                                        content,
                                        SizedBox(height: 20),

                                        // Action icons
                                        peopleActions
                                      ])))
                        ],
                      ),
                    ),

                    // Avatar
                    avatar
                  ],
                ))));
  }
}
