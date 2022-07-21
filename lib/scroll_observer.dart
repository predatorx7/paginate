import 'package:flutter/widgets.dart';

import 'controller.dart';

class PaginationScrollUpdateObserver extends StatelessWidget {
  final Widget child;
  final PaginationDataController controller;

  const PaginationScrollUpdateObserver({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: controller.onScrollUpdate,
      child: child,
    );
  }
}
