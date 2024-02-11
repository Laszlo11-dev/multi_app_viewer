import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../dialog/item_config_dialog.dart';
import '../model/item.dart';
import '../model/item_configuration.dart';
import 'frame_widget.dart';
import 'item_inherited.dart';
import 'tilt_widget.dart';

class ItemWidget extends StatefulWidget {
  final MavItem item;
  final ItemBuilder itemBuilder;

  const ItemWidget({super.key, required this.item, required this.itemBuilder});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: widget.item.frame.isEditMode
              ? () {
                  add(context, configuration: widget.item.configuration);
                }
              : null,
          child: Tilt(
            configuration: widget.item.configuration,
            frame: widget.item.frame,
            child: Material(
              key: Key(widget.item.identifier),
              color: widget.item.configuration.backgroundColor ??
                  widget.item.frame.frameConfiguration.backgroundColor,
              elevation: 0,
              child: Column(
                children: [
                  if (widget.item.configuration.title?.isNotEmpty ?? false)
                    Html(
                      key: Key(widget.item.configuration.title!),
                      shrinkWrap: true,
                      data: widget.item.configuration.title,
                      style: const {},
                    ),
                  if (!widget.item.configuration.isTextOnly)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: widget.item.configuration.useFrame
                            ? DeviceFrame(
                                key: Key(widget.item.identifier),
                                device: widget.item.configuration.deviceInfo!,
                                isFrameVisible: true,
                                orientation:
                                    widget.item.configuration.orientation,
                                screen: LayoutBuilder(
                                  builder: (context, w) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            platformBrightness: widget
                                                .item.configuration.brightness,
                                            size: Size(constraint.maxWidth / 2,
                                                constraint.maxHeight)),
                                        child: MavItemInherited(
                                          item: widget.item,
                                          child: widget.itemBuilder(
                                            widget.item,
                                          ),
                                        ));
                                  },
                                ),
                              )
                            : Material(
                                elevation: 8,
                                child: LayoutBuilder(
                                  builder: (context, w) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            platformBrightness: widget
                                                .item.configuration.brightness,
                                            size: Size(constraint.maxWidth / 2,
                                                constraint.maxHeight)),
                                        child: MavItemInherited(
                                          item: widget.item,
                                          child: widget.itemBuilder(
                                            widget.item,
                                          ),
                                        ));
                                  },
                                ),
                              ),
                      ),
                    ),
                  if (widget.item.configuration.description?.isNotEmpty ??
                      false)
                    Html(
                      key: Key(widget.item.configuration.description!),
                      shrinkWrap: true,
                      data: widget.item.configuration.description,
                      style: const {},
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> add(BuildContext context,
      {ItemConfiguration? configuration}) async {
    await showDialog(
        context: context,
        builder: (c) {
          return ItemConfigDialog(
            frame: widget.item.frame,
            isNew: configuration == null,
            configuration:
                configuration ?? ItemConfiguration(title: 'New', id: ''),
          );
        });
  }
}
