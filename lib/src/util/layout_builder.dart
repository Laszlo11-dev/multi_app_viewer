import 'package:flutter/material.dart';

import '../widget/dashboard/dashboard.dart';
import '../model/frame.dart';
import '../widget/stepper_stack.dart';

typedef LayoutBuilderType = Widget Function(
    {required List<Widget> children, required MavFrame frame});

Widget frameLayoutRow(
    {required List<Widget> children, required MavFrame frame}) {
  return Row(
      mainAxisSize: MainAxisSize.max,
      children: children.map((e) => Expanded(child: e)).toList());
}

Widget frameLayoutColumn(
    {required List<Widget> children, required MavFrame frame}) {
  return Column(
      mainAxisSize: MainAxisSize.max,
      children: children.map((e) => Expanded(child: e)).toList());
}

Widget frameLayoutDashboard(
    {required List<Widget> children, required MavFrame frame}) {
  return DashboardWidget(
    key: Key(frame.id),
    frame: frame,
    children: children,
  );
}

Widget frameLayoutStack(
    {required List<Widget> children, required MavFrame frame}) {
  return Row(
    children: [
      Expanded(child: StepperStack(children: children)),
    ],
  );
}

const Map<LayoutType, LayoutBuilderType?> layouts = {
  LayoutType.row: frameLayoutRow,
  LayoutType.column: frameLayoutColumn,
  LayoutType.dashboard: frameLayoutDashboard,
  LayoutType.stack: frameLayoutStack,
};

LayoutBuilderType? getLayout(LayoutType layoutType) {
  return layouts[layoutType];
}
