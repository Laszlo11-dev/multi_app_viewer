import 'dart:convert';
import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import '../util/navigation_observer.dart';
import '../../multi_app_viewer.dart';

enum NavigationType { push, pushNamed, pop }

enum LayoutType { row, column, stack, dashboard }

MavFrame frame =
    MavFrame(isEditMode: true, frameConfiguration: FrameConfiguration.base());
ValueNotifier<MavFrame> mainNotifier = ValueNotifier(frame);

class MavFrame extends ChangeNotifier {
  FrameConfiguration frameConfiguration;
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  bool isToolbarHidden = false;

  bool get isEditMode => frameConfiguration.isEditMode;

  set isEditMode(bool value) {
    frameConfiguration.isEditMode = value;
  }

  List<MavItem> items = [];
  Map<String, ValueNotifier> eventBus = {};
  static List<dynamic> autoRunScript = [];
  static List<dynamic> buttonScript = [];
  static bool autoRepeat = false;

  ValueNotifier<List<MavItem>> itemConfigNotifier =
      ValueNotifier<List<MavItem>>([]);

  DashboardItemController<MavItem>? dashboardItemController;

  static List<FrameConfiguration> preferredList = [
    FrameConfiguration.dashboard(),
    FrameConfiguration.lot(),
    FrameConfiguration.base(),
    FrameConfiguration.baseNoFrame()
  ];

  MavFrame.all({required this.frameConfiguration});

  MavFrame({required this.frameConfiguration, bool isEditMode = false}) {
    frameConfiguration.isEditMode = isEditMode;
    makeItems();
  }

  makeItems() {
    int index = 0;
    items.clear();
    for (ItemConfiguration configuration in frameConfiguration.configurations) {
      configuration.id = '$index';
      items.add(MavItem(
          configuration: configuration,
          navigatorObserver: MavNavigatorObserver(this, index),
          navigatorKey: GlobalKey<NavigatorState>(),
          index: index++,
          frame: this,
          width: configuration.width ?? 4,
          height: configuration.height ?? 4,
          startX: configuration.left,
          startY: configuration.top,
          identifier: '$id-${configuration.id}'));
    }
    // itemConfigNotifier.value = items;
    // itemConfigNotifier.notifyListeners();
  }

  update() {
    makeItems();
    id = DateTime.now().microsecondsSinceEpoch.toString();
    dashboardItemController?.clear();
    dashboardItemController?.addAll(items);
    mainNotifier.value = this;
    mainNotifier.notifyListeners();
  }

  Future<void> passOnNavigation(int sourceIndex, String routeName,
      {Object? arguments}) async {
    if (sourceIndex < 1) {
      await Future.delayed(const Duration(microseconds: 200));
      for (MavItem item in items) {
        item.onNavigationCallback
            ?.call(routeName, sourceIndex, arguments: arguments);
      }
    }
  }

  publish(String key, dynamic value) {
    if (eventBus[key] == null) {
      eventBus[key] = ValueNotifier(null);
    }
    eventBus[key]!.value = value;
  }

  String jsonString() {
    Map<String, dynamic> jsonMap = frameConfiguration.toJson();
    jsonMap.removeWhere((k, v) => v == null || (v is bool && !v));
    // (k, v) => v == null || (v is int && v == 0) || (v is bool && !v));
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(jsonMap);
  }

  static loadConfiguration(FrameConfiguration frameConfiguration) {
    mainNotifier.value.frameConfiguration = frameConfiguration;
    mainNotifier.value.id = DateTime.now().microsecondsSinceEpoch.toString();
    mainNotifier.value.update();
  }

  void toggleToolbar({bool? shouldShow}) {
    isToolbarHidden = shouldShow ?? !isToolbarHidden;
    mainNotifier.value = this;
    mainNotifier.notifyListeners();
  }

  bool isRunning = false;

  Future<void> animatePreferredList({Duration? stepDuration}) async {
    List<dynamic> script = [
      preferredList[1],
      (-1, 'details', {'id1': '33'}),
      (-1, '/', {'id1': '33'}),
      ('_counterValue', 99)
    ];
    runScript(script);
  }

  Future<void> runScript(
    List<dynamic> steps, {
    Duration? stepDuration = const Duration(seconds: 2),
  }) async {
    if (!isRunning) {
      do {
        isRunning = true;
        for (dynamic step in steps) {
          switch (step) {
            case FrameConfiguration _:
              loadConfiguration(step);
              update();
            case (int sourceIndex, String routeName, Object? arguments) r:
              passOnNavigation(r.$1, r.$2, arguments: r.$3);
            case (String key, dynamic value) v:
              publish(v.$1, v.$2);
            case _:
              null;
          }
          await Future.delayed(stepDuration ?? const Duration(seconds: 2));
          if (!isRunning) break;
        }
      } while (autoRepeat && isRunning);
    }
    isRunning = false;
    update();
  }
}
