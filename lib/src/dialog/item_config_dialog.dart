import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../model/frame.dart';
import '../model/item_configuration.dart';
import '../util/extensions.dart';
import '../widget/labelled_dropdown.dart';

class ItemConfigDialog extends StatefulWidget {
  final MavFrame? frame;
  final ItemConfiguration configuration;
  final bool isNew;

  const ItemConfigDialog(
      {super.key, this.frame, required this.configuration, this.isNew = false});

  @override
  State<ItemConfigDialog> createState() => _ItemConfigDialogState();
}

class _ItemConfigDialogState extends State<ItemConfigDialog> {
  Color color = Colors.red;
  late TextEditingController titleController =
      TextEditingController(text: widget.configuration.title);
  late TextEditingController descriptionController =
      TextEditingController(text: widget.configuration.description);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LabelledDropDown<Brightness?>(
                        items: Brightness.values.sortEnum<Brightness>(),
                        label: 'Brightness: ',
                        value: widget.configuration.brightness,
                        defaultValue: Brightness.light,
                        // disabled: disabled,
                        onChanged: (Brightness newValue) {
                          setState(() {
                            widget.configuration.brightness = newValue;
                            // refresh();
                          });
                        },
                      ),
                      LabelledDropDown<TargetPlatform?>(
                        items: TargetPlatform.values.sortEnum<TargetPlatform>(),
                        label: 'Platform: ',
                        value: widget.configuration.targetPlatform,
                        defaultValue: TargetPlatform.android,
                        // disabled: disabled,
                        onChanged: (TargetPlatform newValue) {
                          setState(() {
                            widget.configuration.targetPlatform = newValue;
                            // refresh();
                          });
                        },
                      ),
                      LabelledDropDown<TextDirection?>(
                        items: TextDirection.values.sortEnum<TextDirection>(),
                        label: 'Direction: ',
                        value: widget.configuration.textDirection,
                        defaultValue: TextDirection.ltr,
                        // disabled: disabled,
                        onChanged: (TextDirection newValue) {
                          setState(() {
                            widget.configuration.textDirection = newValue;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Show frame'),
                              Checkbox(
                                  value: widget.configuration.useFrame,
                                  onChanged: (b) {
                                    setState(() {
                                      widget.configuration.useFrame = b ?? true;
                                    });
                                  }),
                              const Text('Text only'),
                              Checkbox(
                                  value: widget.configuration.isTextOnly,
                                  onChanged: (b) {
                                    setState(() {
                                      widget.configuration.isTextOnly =
                                          b ?? true;
                                    });
                                  }),
                            ]),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: LabelledDropDown<DeviceInfo?>(
                              items: Devices.all,
                              label: 'Device frame: ',
                              value: widget.configuration.deviceInfo,
                              defaultValue: Devices.ios.iPhone13ProMax,
                              toLabel: (t) =>
                                  '${enumName(t.identifier.platform.toString())} - ${t.identifier.name}',
                              // disabled: disabled,
                              onChanged: (DeviceInfo newValue) {
                                setState(() {
                                  widget.configuration.deviceInfo = newValue;
                                  // refresh();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      LabelledDropDown<Orientation?>(
                        items: Orientation.values,
                        label: 'Orientation: ',
                        value: widget.configuration.orientation,
                        defaultValue: Orientation.portrait,
                        onChanged: (Orientation newValue) {
                          setState(() {
                            widget.configuration.orientation = newValue;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Title'),
                          controller: titleController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          controller: descriptionController,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Color: "),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 160,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: MaterialPicker(
                                  pickerColor:
                                      widget.configuration.backgroundColor ??
                                          Colors.grey.shade100,
                                  onColorChanged: (c) {
                                    setState(() {
                                      widget.configuration.backgroundColor = c;
                                    });
                                  }),
                              // child: BlockPicker(
                              //     pickerColor: color,
                              //     onColorChanged: (c) {
                              //       setState(() {
                              //         widget.configuration.backgroundColor = c;
                              //       });
                              //     }),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                if (!widget.isNew)
                  ElevatedButton(
                      onPressed: () {
                        widget.frame?.frameConfiguration.configurations
                            .remove(widget.configuration);
                        widget.frame?.update();
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                        child: Text('Delete'),
                      )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      child: Text('Cancel'),
                    )),
                ElevatedButton(
                    onPressed: () {
                      widget.configuration.title = titleController.text;
                      widget.configuration.description =
                          descriptionController.text;
                      if (widget.isNew) {
                        widget.frame?.frameConfiguration.configurations
                            .add(widget.configuration);
                      }
                      widget.frame?.update();
                      if (widget.frame?.items.last != null &&
                          widget.frame?.frameConfiguration.layoutType ==
                              LayoutType.dashboard) {
                        widget.frame?.dashboardItemController
                            ?.add(widget.frame!.items.last);
                      }
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 30),
                      child: Text(widget.isNew ? 'Add' : 'OK'),
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
