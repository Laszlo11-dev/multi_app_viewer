import 'package:flutter/material.dart';

import '../model/frame.dart';

class MavNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  final MavFrame frame;
  final int index;

  MavNavigatorObserver(this.frame, this.index);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // if (kDebugMode) {
    //   print(
    //       'Pop-${route.settings.toString()} --> ${previousRoute?.settings.name}');
    // }
    frame.passOnNavigation(index, previousRoute?.settings.name ?? '',
        arguments: previousRoute?.settings.arguments);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // if (kDebugMode) {
    //   print('Push-${route.settings.toString()}');
    // }
    frame.passOnNavigation(index, route.settings.name ?? '',
        arguments: route.settings.arguments);
  }
}
