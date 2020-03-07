import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  Carousel({
    Key key,
    @required this.children,
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
  final List<Widget> children;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
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

  /// Helper transform list children to insert [Draggable] widget
  /// Return [List<Widget>]
  List<Widget> _transformChildren() => widget.children.reversed
      .map(
        (item) => Draggable(
          onDragEnd: _onDragEnd,
          childWhenDragging: Container(height: 0, width: 0),
          feedback: item,
          child: item,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: _transformChildren()));
  }
}
