import 'package:example/core/models/people.dart';
import 'package:flutter/material.dart';

import 'people_card.dart';

class PeopleCarousel extends StatefulWidget {
  PeopleCarousel({
    Key key,
    @required this.peoples,
    this.onRightSwipe,
    this.onLeftSwipe,
    this.swipeThreshold = 20,
  }) : super(key: key);

  /// Delta x when swiping to trigger the snap
  final double swipeThreshold;

  /// Callback fired after snapping to right
  final VoidCallback onRightSwipe;

  /// Callback fired after snapping to left
  final VoidCallback onLeftSwipe;

  /// List widgets children
  final List<People> peoples;

  @override
  _PeopleCarouselState createState() => _PeopleCarouselState();
}

class _PeopleCarouselState extends State<PeopleCarousel> {
  static const String ON_LEFT = "ON_LEFT";
  static const String ON_RIGHT = "ON_RIGHT";
  static const double ACTIVE_DRAG_DX = 0.0;
  double lastPositon = 5;

  /// Find target Draggable
  /// Return [String] if target is found, else return [null]
  String _findTarget(DraggableDetails dragDetails) {
    // Get delta X and swipeThreshold from draggable details and props
    double deltaX = dragDetails.offset.dx;
    double swipeThreshold = widget.swipeThreshold;

    if (deltaX > ACTIVE_DRAG_DX && deltaX > swipeThreshold) return ON_RIGHT;
    if (deltaX < ACTIVE_DRAG_DX && deltaX < swipeThreshold) return ON_LEFT;

    return null;
  }

  /// Function binding to props callback when drag to left
  void _onDragToLeft() {
    if (widget.onLeftSwipe != null) widget.onLeftSwipe();
  }

  /// Function binding to props callback when drag to right
  void _onDragToRight() {
    if (widget.onLeftSwipe != null) widget.onRightSwipe();
  }

  /// Callback event for [Draggable] widget
  void _onDragEnd(DraggableDetails drag) {
    String target = _findTarget(drag);

    if (target == ON_RIGHT) _onDragToRight();
    if (target == ON_LEFT) _onDragToLeft();

    lastPositon = 5;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: widget.peoples.reversed
                .map(
                  (people) => new PeopleCardDraggable(
                    key: Key(people.username),
                    people: people,
                    width: 300,
                    height: 350,
                    onDragEnd: _onDragEnd,
                  ),
                )
                .toList()));
  }
}

class PeopleCardDraggable extends StatefulWidget {
  PeopleCardDraggable({
    Key key,
    this.width,
    this.height,
    this.people,
    this.onDragEnd,
    this.onActiveIndexChange,
  }) : super(key: key);

  /// Props
  final double width;
  final double height;
  final People people;
  final Function(DraggableDetails) onDragEnd;
  final Function(int) onActiveIndexChange;

  @override
  _PeopleCardDraggableState createState() => _PeopleCardDraggableState();
}

class _PeopleCardDraggableState extends State<PeopleCardDraggable> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget content = new PeopleCard(
      address: widget.people.address,
      avatar: widget.people.picture,
      width: widget.width,
      height: widget.height,
      username: widget.people.username,
      password: widget.people.password,
      picture: widget.people.picture,
      phone: widget.people.phone,
      cell: widget.people.cell,
      name: widget.people.fullName,
      initActiveIndex: activeIndex,
      onActiveIndexChange: (i) {
        setState(() {
          activeIndex = i;
        });
      },
    );

    return Draggable(
      feedback: content,
      child: content,
      onDragEnd: widget.onDragEnd,
      childWhenDragging: Container(width: 0, height: 0),
    );
  }
}
