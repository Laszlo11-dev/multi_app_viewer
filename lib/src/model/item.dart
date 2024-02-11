import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';

import '../util/navigation_observer.dart';

typedef OnNavigationCallback = void Function(String routeName, int index,
    {Object? arguments})?;

class MavItem extends DashboardItem {
  ItemConfiguration configuration;
  GlobalKey<NavigatorState> navigatorKey;
  MavNavigatorObserver navigatorObserver;
  int index = 0;

  OnNavigationCallback onNavigationCallback;
  MavFrame frame;
  Map<String, void Function()> listeners = {};

  MavItem(
      {required this.configuration,
      required this.navigatorKey,
      required this.navigatorObserver,
      this.onNavigationCallback,
      required this.index,
      required this.frame,
      required super.width,
      required super.height,
      super.startX,
      super.startY,
      required super.identifier});

  bool get master => index == 0;

  publish(String key, dynamic value) {
    if (master) {
      frame.publish(key, value);
    }
  }

  listen(String key, Function(dynamic value) onchange) {
    if (frame.eventBus[key] == null) {
      frame.eventBus[key] = ValueNotifier(null);
    } else {
      if (listeners[key] != null) {
        frame.eventBus[key]!.removeListener(listeners[key]!);
      }
    }
    listeners[key] = () {
      // print('$index --> ${frame.eventBus[key]?.value}');
      onchange(frame.eventBus[key]?.value);
    };
    frame.eventBus[key]!.addListener(listeners[key]!);
  }

  dispose(String key) {
    frame.eventBus[key]!.removeListener(listeners[key]!);
  }

  updateConfig() {
    configuration.width = layoutData.width;
    configuration.height = layoutData.height;
    configuration.top = layoutData.startY;
    configuration.left = layoutData.startX;
  }
}
