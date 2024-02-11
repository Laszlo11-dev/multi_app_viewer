import 'dart:math';

import 'package:flutter/material.dart';
import '../util/extensions.dart';

class ResponsiveToolbar extends StatefulWidget {
  final List<ToolbarItem> items;
  final double maxWidth;
  final double itemWidth;
  final double iconSize;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool withText;

  ResponsiveToolbar(
      {super.key,
      required this.items,
      this.withText = false,
      this.maxWidth = 240,
      this.itemWidth = 48,
      this.iconSize = 24,
      this.backgroundColor = const Color(0xffF0F0F0),
      Color? foregroundColor})
      : foregroundColor = foregroundColor ?? backgroundColor.onThis();

  @override
  State<ResponsiveToolbar> createState() => _ResponsiveToolbarState();
}

class _ResponsiveToolbarState extends State<ResponsiveToolbar> {
  List<Widget> shown = [];
  List<Widget> overflowed = [];
  double itemSize = 40;
  @override
  Widget build(BuildContext context) {
    itemSize = widget.withText ? widget.itemWidth * 4 : widget.itemWidth;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      int shownCount = ((constraints.maxWidth == double.infinity
                      ? widget.maxWidth
                      : constraints.maxWidth) /
                  itemSize)
              .truncate() -
          1;
      if (shownCount + 1 == widget.items.length) shownCount++;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.items
              .map((e) => widget.withText ? buildTile(e) : buildIconButton(e))
              .toList()
              .sublist(0, min(shownCount, widget.items.length)),
          if (shownCount < widget.items.length)
            Theme(
              data: Theme.of(context).copyWith(
                cardColor: widget.backgroundColor,
              ),
              child: PopupMenuButton(
                  offset: const Offset(0, 40),
                  icon: Icon(
                    Icons.more_vert,
                    color: widget.foregroundColor,
                  ),
                  itemBuilder: (c) => widget.items
                      .sublist(shownCount, widget.items.length)
                      .map((e) => PopupMenuItem(
                            child: ColoredBox(
                                color: widget.backgroundColor,
                                child: ListTile(
                                  title: Text(e.caption),
                                  textColor: widget.foregroundColor,
                                  leading: Icon(
                                    e.icon,
                                    color: widget.foregroundColor,
                                  ),
                                  onTap: () {
                                    // if (!widget.withText)
                                    Navigator.of(context).pop();
                                    e.onPressed?.call();
                                  },
                                )),
                          ))
                      .toList()),
            ),
        ],
      );
    });
  }

  Widget buildIconButton(ToolbarItem item) {
    return IconButton(
      padding: const EdgeInsets.only(right: 16.0, left: 8.0),
      onPressed: () {
        item.onPressed?.call();
      },
      isSelected: item.isSelected,
      tooltip: item.caption,
      icon: item.isSelected ?? false
          ? Icon(
              item.icon,
              // item.icon,
              size: widget.iconSize,
              // color: widget.backgroundColor.getShadeColor(),
            )
          : Icon(
              item.icon,
              size: widget.iconSize,
              color: widget.foregroundColor,
            ),
    );
  }

  Widget buildTile(ToolbarItem item) {
    return Container(
        width: itemSize,
        // color: Colors.white,
        color: (item.isSelected ?? false)
            ? widget.foregroundColor
            : widget.backgroundColor,
        child: ListTile(
          title: Text(item.caption),
          textColor: !(item.isSelected ?? false)
              ? widget.foregroundColor
              : widget.backgroundColor,
          leading: Icon(
            item.icon,
            color: !(item.isSelected ?? false)
                ? widget.foregroundColor
                : widget.backgroundColor,
          ),
          onTap: () {
            // if (!widget.withText) Navigator.of(context).pop();
            item.onPressed?.call();
            setState(() {
              item.isSelected = !(item.isSelected ?? false);
            });
          },
        ));

    // return IconButton(
    //   padding: const EdgeInsets.only(right: 16.0, left: 8.0),
    //   onPressed: () {
    //     item.onPressed?.call();
    //   },
    //   isSelected: item.isSelected,
    //   tooltip: item.caption,
    //   icon: item.isSelected ?? false
    //       ? Icon(
    //           item.icon,
    //           // item.icon,
    //           size: widget.iconSize,
    //           color: widget.backgroundColor.getShadeColor(),
    //         )
    //       : Icon(
    //           item.icon,
    //           size: widget.iconSize,
    //           // color: minimalFontColor,
    //         ),
    // );
  }
}

class ToolbarItem {
  String caption;
  IconData icon;
  Function? onPressed;
  // ScreenBuilder? screenBuilder;
  // ScreenType? screenType;
  bool? isSelected;

  ToolbarItem({
    required this.caption,
    required this.icon,
    this.onPressed,
    // this.screenBuilder,
    // this.screenType,
    this.isSelected,
  });

  @override
  String toString() {
    return 'ToolbarItem{caption: $caption, icon: $icon, onPressed: $onPressed, isSelected: $isSelected}';
  }
}
