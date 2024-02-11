import 'package:flutter/material.dart';

/*
 import 'package:flutter_app2/util/extensions.dart';
*/

extension ConvenienceN on String? {
  bool hasContent({String? noContent}) {
    return this != null && this!.isNotEmpty && this != noContent;
  }

  bool startsWithAny(List<String> items) {
    return items.any((element) => this!.startsWith(element));
  }

  bool hasNoContent() {
    return this == null || this!.isEmpty;
  }

  String? emptyValue(String? value) {
    return (this == null || this!.isEmpty) ? value : this;
  }

  String? initials() {
    return this!.split(" ").map((n) => n[0]).join(".");
  }

  String? ellipsize(int maxLength) {
    if (this == null || this!.length <= (maxLength)) return this;
    return '${this!.substring(0, maxLength)}…';
  }

  // int? toInt() => int.tryParse(this);
  //
  // String? capitalize() => '${this[0].toUpperCase()}${substring(1)}';
  //
  // String minuscule() => '${this[0].toLowerCase()}${substring(1)}';

  String? sureLeft(int? maxLength) {
    if (this == null || this!.length <= (maxLength ?? this!.length)) {
      return this;
    }
    return this!.substring(0, maxLength);
  }

  String safeAppend(String toAdd) {
    return this == null ? toAdd : '$this$toAdd';
  }

  bool containsNoCase(String searchFor) {
    return this != null &&
        this!.toLowerCase().contains(searchFor.toLowerCase());
  }
}

extension Convenience on String {
  bool hasContent({String? noContent}) {
    return isNotEmpty && this != noContent;
  }

  bool startsWithAny(List<String> items) {
    return items.any((element) => startsWith(element));
  }

  bool hasNoContent() {
    return isEmpty;
  }

  String? emptyValue(String? value) {
    return (length == 0) ? value : this;
  }

  String initials() {
    return split(" ").map((n) => n[0]).join(".");
  }

  String ellipsize(int? maxLength) {
    if (length <= (maxLength ?? length)) return this;
    return '${substring(0, maxLength)}…';
  }

  int? toInt() => int.tryParse(this);

  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  String minuscule() => '${this[0].toLowerCase()}${substring(1)}';

  String sureLeft(int maxLength) {
    if (length <= (maxLength)) return this;
    return substring(0, maxLength);
  }

  String safeAppend(String toAdd) {
    return '$this$toAdd';
  }
}

extension MapUtils on Map? {
  bool hasItem() {
    return this != null &&
        this!.isNotEmpty &&
        (this!.values.any((element) => element != null));
  }

  MapEntry? safeFirst() {
    if (this == null || this!.isEmpty) return null;
    return this!.entries.first;
  }
}

// extension iterableUtils on Iterable {
//   bool hasItem() {
//     return this != null && length > 0 && (any((element) => element != null));
//   }
// }

extension ListUtils on List? {
  bool hasItem() {
    return this != null &&
        this!.isNotEmpty &&
        (this!.any((element) => element != null));
  }

  List get nvl => this == null ? [] : this!;

  bool? hasIntersect(List<dynamic>? other) {
    if (this == null || other == null) return null;
    return (this!.any((item) => other.contains(item)));
  }

  T? nextValue<T>(T item) {
    if (this == null) return null;
    int pos = this!.indexOf(item);
    if (pos == -1) return null;
    return this![(pos + 1) % this!.length];
  }

  List<T?>? sortEnum<T>() {
    if (this is List<T>) {
      List<T> tmp = [];
      for (var element in this!) {
        if (element is T) tmp.add(element);
      }
      tmp.sort((a, b) => (enumName(a.toString()) ?? '')
          .compareTo(enumName(b.toString()) ?? ''));
      return tmp;
    }
    return this as List<T?>?;
  }

  T? safeFirst<T>({bool withContent = false}) {
    if (this == null || this!.isEmpty) return null;
    if (withContent) {
      return this!.firstWhere((element) => element.hasContent(), orElse: () {
        return null;
      });
    }
    return this!.first;
  }

  bool toggleItem<T>(T item) {
    if (this != null) {
      if (!this!.contains(item)) {
        this!.add(item);
        return true;
      } else {
        this!.remove(item);
        return false;
      }
    }
    return false;
  }

  bool addSafe<T>(T item) {
    if (this != null) {
      if (!this!.contains(item)) {
        this!.add(item);
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void addIfNotNull<T>(T item) {
    if (item != null) {
      this?.add(item);
    }
  }
}

extension Specials on DateTime {
  DateTime today() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime asDay() {
    return DateTime(year, month, day);
  }

  bool dateEqual(DateTime? other) {
    return year == other?.year && month == other?.month && day == other?.day;
  }

  bool yearEqual(DateTime? other) {
    return year == other?.year;
  }
}

extension Convert on int {
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  String toHex({int? defaultValue}) {
    return (this).toRadixString(16);
  }
}

DateTime? dateTimeFromInt(int? from) {
  if (from == null) {
    return null;
  }
  return DateTime.fromMillisecondsSinceEpoch(from);
}

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);

  TextStyle withColor(Color value) => copyWith(color: value);
}

String? capitalizeFirstLetter(String? s) =>
    (s?.isNotEmpty ?? false) ? '${s![0].toUpperCase()}${s.substring(1)}' : s;

bool notEmpty(String? text) {
  return text != null && text.isNotEmpty;
}

String? enumName(String? enumString) {
  return capitalizeFirstLetter(enumString?.split('.').last);
}

extension ColorHelpers on Color? {
  Color onThis() {
    if (this == null) return Colors.black;
    return ThemeData.estimateBrightnessForColor(this!) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
