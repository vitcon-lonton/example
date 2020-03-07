import 'package:flutter/widgets.dart';

mixin BaseScreenMixin<T extends StatefulWidget> on State<T> {
  String routeName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
  }

  @protected
  @mustCallSuper
  void afterFirstLayout(BuildContext context) {
    routeName = ModalRoute.of(context).settings.name;
  }
}
