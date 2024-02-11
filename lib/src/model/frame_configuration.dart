import 'dart:convert';

import 'package:flutter/material.dart';

import '../../multi_app_viewer.dart';
import '../util/util.dart';

/// Configures how the whole screen looks like
///
/// [title] appears on top and may use basic HTML.
/// /// e.g. <h2>My best app</h2>
///
/// [tilt] is for the whole internal area
///
/// [layoutType] is row, column, stack or dashboard
///
/// All of them are editable interactively or can be programmed
///

class FrameConfiguration {
  bool isEditMode = false;
  bool isTiltMode = false;
  bool isFullScreen = false;
  String? name;
  String? title;
  String? description;
  Color? backgroundColor;

  Offset? tilt = const Offset(0.0, 0.0);
  TextDirection? textDirection;
  LayoutType layoutType = LayoutType.row;
  List<ItemConfiguration> configurations = [];

  FrameConfiguration.all(
      {this.isTiltMode = false,
      this.isEditMode = false,
      this.isFullScreen = false,
      this.name,
      this.title,
      this.description,
      this.backgroundColor,
      this.tilt,
      this.textDirection,
      required this.layoutType,
      required this.configurations});

  Map<String, dynamic> toJson() {
    return {
      "configurations": configurations.map((e) => e.toJson()).toList(),
      "name": name,
      "title": title,
      "description": description,
      "backgroundColor": backgroundColor?.value,
      // "padding": padding,
      "layoutType": layoutType.index,
      if (tilt != null) 'tilt': {'x': tilt?.dx, 'y': tilt?.dy},
    };
  }

  factory FrameConfiguration.fromJson(Map<String, dynamic> json) {
    return FrameConfiguration.all(
      configurations: json["configurations"]
          .map<ItemConfiguration>((c) => ItemConfiguration.fromJson(c))
          .toList(),
      name: json["name"],
      title: json["title"],
      description: json["description"],
      backgroundColor: colorOrNull(json["backgroundColor"]),
      layoutType: LayoutType.values[json["layoutType"] ?? 1],
      tilt: Offset(json["tilt"]?['x'] ?? 0, json['tilt']?["y"] ?? 0),
    );
  }

  static FrameConfiguration fromFile(String path) {
    void load() async {
      Map<String, dynamic> ize = await readJsonFile(path);
      if (ize.isNotEmpty) {
        MavFrame.loadConfiguration(FrameConfiguration.fromJson(ize));
      }
    }

    load();
    return FrameConfiguration.base();
  }

  FrameConfiguration.base() {
    name = 'Base';
    configurations = [
      ItemConfiguration(
          title: '<h3>Light</h3>', brightness: Brightness.light, id: '0'),
      ItemConfiguration(
          id: '1',
          title: '<h3>Dark</h3>',
          brightness: Brightness.dark,
          textDirection: TextDirection.ltr,
          targetPlatform: TargetPlatform.macOS),
    ];
  }

  FrameConfiguration.baseNoFrame() {
    name = 'Base, no frame';
    configurations = [
      ItemConfiguration(
          title: '<h3>Light</h3>',
          brightness: Brightness.light,
          id: '0',
          useFrame: false),
      ItemConfiguration(
          id: '1',
          title: '<h3>Dark</h3>',
          brightness: Brightness.dark,
          textDirection: TextDirection.ltr,
          targetPlatform: TargetPlatform.macOS,
          useFrame: false),
    ];
  }

  void resetTilt() {
    tilt = null;
    for (var element in configurations) {
      element.tilt = null;
    }
  }

  factory FrameConfiguration.dashboard() {
    return FrameConfiguration.fromJson(jsonDecode('''
    { "configurations": [
     {
      "id": "0",
      "title": "Light",
      "brightness": 1,
      "targetPlatform": 0,
      "textDirection": 0,
      "orientation": 0,
      "useFrame": true,
      "deviceInfo": "iPhone 13 Pro Max",
      "width": 2,
      "height": 4,
      "left": 0,
      "top": 0
    },
    {
      "id": "1",
      "title": "<b>Dark</b>",
      "brightness": 0,
      "targetPlatform": 4,
      "textDirection": 1,
      "orientation": 0,
      "useFrame": true,
      "deviceInfo": "iPhone 13 Pro Max",
      "width": 3,
      "height": 4,
      "left": 5,
      "top": 0
    },
    {
      "id": "2",
      "title": "Ios",
      "brightness": 0,
      "targetPlatform": 2,
      "textDirection": 1,
      "orientation": 1,
      "useFrame": true,
      "deviceInfo": "iPhone 13 Pro Max",
      "width": 3,
      "height": 3,
      "left": 2,
      "top": 2
    },
    {
      "id": "3",
      "title": "New",
      "orientation": 1,
      "useFrame": true,
      "deviceInfo": "iPhone 13 Pro Max",
      "width": 3,
      "height": 2,
      "left": 2,
      "top": 0
    }
  ],
  "name": "Dashboard",
  "title": "<h3>Responsive and multiplatform</h3>",
  "layoutType": 3
  }
    '''));
  }

  factory FrameConfiguration.lot() {
    return FrameConfiguration.fromJson(jsonDecode('''{
    "configurations": [
    {
    "id": "0",
    "title": "<h3>Light</h3>",
    "brightness": 1,
    "targetPlatform": 0,
    "textDirection": 0,
    "orientation": 0,
    "useFrame": true,
    "deviceInfo": "iPhone 13 Pro Max"
    },
    {
    "id": "1",
    "title": "<h3>Dark</h3>",
    "brightness": 0,
    "targetPlatform": 4,
    "textDirection": 1,
    "orientation": 0,
    "useFrame": true,
    "deviceInfo": "iPad"
    },
    {
    "id": "2",
    "title": "<h2>Tablet</h2>",
    "brightness": 0,
    "targetPlatform": 0,
    "textDirection": 0,
    "orientation": 0,
    "useFrame": true,
    "deviceInfo": "Samsung Galaxy A50"
    },
    {
    "id": "3",
    "title": "<h2>Windows</h2>",
    "brightness": 0,
    "targetPlatform": 0,
    "textDirection": 0,
    "orientation": 0,
    "useFrame": true,
    "deviceInfo": "Laptop"
    },
    {
    "id": "4",
    "title": "<h2>Mac</h2>",
    "brightness": 0,
    "targetPlatform": 0,
    "textDirection": 0,
    "orientation": 0,
    "useFrame": true,
    "deviceInfo": "MacBook Pro"
    }
        ],
        "name": "Lot",
        "title": "<h2>Everywhere</h2>",
        "description": "",
        "backgroundColor": 4289912795,
        "layoutType": 0
    }'''));
  }
}
