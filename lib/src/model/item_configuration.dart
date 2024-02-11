import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';

class ItemConfiguration {
  String? title;
  String? description = '<h3>item.configuration.description </h3>'
      'With Flutter:';
  String id;
  Brightness? brightness;
  TargetPlatform? targetPlatform;
  Orientation orientation = Orientation.landscape;
  late DeviceInfo? deviceInfo;

  bool useFrame = true;

  TextDirection? textDirection;
  Color? backgroundColor;
  bool isTextOnly;
  int? width;
  int? height;
  int? left;
  int? top;
  Offset? tilt = const Offset(0.0, -0.0);
  // Offset? tilt = const Offset(0.1, -0.2);

  ItemConfiguration(
      {required this.id,
      this.title,
      this.description,
      this.brightness,
      this.orientation = Orientation.portrait,
      this.useFrame = true,
      this.deviceInfo,
      this.targetPlatform,
      this.textDirection,
      this.backgroundColor,
      this.width,
      this.height,
      this.left,
      this.top,
      this.tilt,
      this.isTextOnly = false}) {
    deviceInfo ??= Devices.ios.iPhone13ProMax;
  }

  factory ItemConfiguration.fromJson(Map<String, dynamic> json) {
    return ItemConfiguration(
      title: json["title"],
      description: json["description"],
      id: json["id"],
      brightness: Brightness.values[json["brightness"] ?? 0],
      targetPlatform: TargetPlatform.values[json["targetPlatform"] ?? 0],
      orientation: Orientation.values[json["orientation"] ?? 0],
      deviceInfo: Devices.all
          .firstWhere((element) => element.name == json["deviceInfo"]),
      textDirection: TextDirection.values[json["textDirection"] ?? 0],
      useFrame: json["useFrame"] ?? false,
      backgroundColor: colorOrNull(json["backgroundColor"]),
      width: json["width"],
      height: json["height"],
      left: json["left"],
      top: json["top"],
      tilt: Offset(json["tilt"]?['x'] ?? 0, json['tile']?["y"] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    var jsonMap = {
      "id": id,
      "title": title,
      "brightness": brightness?.index,
      "targetPlatform": targetPlatform?.index,
      "textDirection": textDirection?.index,
      "orientation": orientation.index,
      "backgroundColor": backgroundColor?.value,
      "isTextOnly": isTextOnly,
      "useFrame": useFrame,
      "deviceInfo": deviceInfo!.name,
      "width": width,
      "height": height,
      "left": left,
      "top": top,
      if (tilt != null) 'tilt': {'x': tilt?.dx, 'y': tilt?.dy},
    };
    jsonMap.removeWhere((k, v) => v == null || (v is bool && !v));
    return jsonMap;
  }
}
