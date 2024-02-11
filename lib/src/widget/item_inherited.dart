import 'package:flutter/widgets.dart';
import '../model/item.dart';

/// Inherited widget to provide MavItem instance to any level of the widget tree
///
/// Added automatically by the [ItemWidget](https://github.com/Laszlo11-dev/multi_app_viewer/blob/680136fc8e6a3e83f90d434d3dbfa5a80d418471/lib/src/widget/item_widget.dart)
///
/// Use only the [maybeOf]

class MavItemInherited extends InheritedWidget {
  const MavItemInherited({
    super.key,
    required this.item,
    required super.child,
  });

  final MavItem item;

  static MavItemInherited? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MavItemInherited>();
  }

  static MavItemInherited of(BuildContext context) {
    final MavItemInherited? result = maybeOf(context);
    assert(result != null, 'No MultiBoard item found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(MavItemInherited oldWidget) => item != oldWidget.item;
}
