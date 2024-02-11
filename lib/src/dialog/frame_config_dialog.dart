import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';
import 'package:multi_app_viewer/src/util/extensions.dart';
import 'package:multi_app_viewer/src/util/util.dart';

import '../widget/labelled_dropdown.dart';

class FrameConfigDialog extends StatefulWidget {
  final MavFrame frame;

  const FrameConfigDialog({
    super.key,
    required this.frame,
  });

  @override
  State<FrameConfigDialog> createState() => _FrameConfigDialogState();
}

class _FrameConfigDialogState extends State<FrameConfigDialog> {
  late TextEditingController titleController =
      TextEditingController(text: widget.frame.frameConfiguration.title);
  late TextEditingController descriptionController =
      TextEditingController(text: widget.frame.frameConfiguration.description);

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LabelledDropDown<LayoutType?>(
                        items: LayoutType.values.sortEnum<LayoutType>(),
                        label: 'Layout: ',
                        value: widget.frame.frameConfiguration.layoutType,
                        defaultValue: LayoutType.row,
                        // disabled: disabled,
                        onChanged: (LayoutType newValue) {
                          setState(() {
                            widget.frame.frameConfiguration.layoutType =
                                newValue;
                            // refresh();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Title'),
                          controller: titleController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          controller: descriptionController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Color: "),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: 200,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: MaterialPicker(
                                    pickerColor: widget.frame.frameConfiguration
                                            .backgroundColor ??
                                        Colors.white,
                                    onColorChanged: (c) {
                                      setState(() {
                                        widget.frame.frameConfiguration
                                            .backgroundColor = c;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
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
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      var ize = await readJsonFile(null, context: context);
                      if (ize.isNotEmpty) {
                        frame.frameConfiguration =
                            FrameConfiguration.fromJson(ize);
                        // mainNotifier.value = f;
                        frame.update();
                      }
                      if (context.mounted) {
                        Navigator.pop(
                          context,
                        );
                      }
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      child: Text('Load'),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      var result = await saveAsFile('mav_config', context);
                      if (result != null) {
                        saveConfig(result);
                      }
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      child: Text('Save as'),
                    )),
                ElevatedButton(
                    onPressed: () {
                      saveConfig('mav_default');
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      child: Text('OK'),
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

  saveConfig(String fileName) {
    widget.frame.frameConfiguration.title = titleController.text;
    widget.frame.frameConfiguration.description = descriptionController.text;
    saveFile(widget.frame.jsonString(), '$fileName.$mavFileExtension');
    widget.frame.update();
    Navigator.pop(
      context,
    );
  }
}
