import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_app_viewer/src/util/screen_recorder.dart';
import '../dialog/file_selector.dart';
import 'util_app.dart' if (dart.library.html) 'util_web.dart';
import 'package:path_provider/path_provider.dart';

const String mavFileExtension = 'mavc';

takeScreenShot(BuildContext context, GlobalKey previewContainer) async {
  RenderRepaintBoundary? boundary = previewContainer.currentContext!
      .findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List? pngBytes = byteData?.buffer.asUint8List();
  String fileName =
      safeFilename('MultiBoard-${DateTime.now().toIso8601String()}');
  fileName = '$fileName.png';
  String directoryPath = 'downloads';
  await saveFile(pngBytes, fileName);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Saved to $directoryPath/$fileName'),
      backgroundColor: Colors.teal,
    ));
  }
}

recordScreen(BuildContext context, ScreenRecorderController controller) async {
  List<int>? gif;

  Future<bool> export() async {
    gif = await controller.exporter.exportGif();
    if (gif == null) {
      throw Exception();
    }
    return true;
  }

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: FutureBuilder(
            future: export(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Rendering...'),
                    Text('This may take several minutes'),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ));
              }
              return Image.memory(Uint8List.fromList(gif!));
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  controller.exporter.clear();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.cancel)),
            IconButton(
                onPressed: () {
                  String fileName = safeFilename(
                      'MultiBoard-${DateTime.now().toIso8601String()}.gif');
                  String directoryPath = 'downloads';
                  saveFile(gif, fileName);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Saved to $directoryPath/$fileName'),
                      backgroundColor: Colors.teal,
                    ));
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.save))
          ],
        );
      },
    );
  }
}

Future<void> saveFile(var bytes, String fileName) async {
  await saveFilePlatform(bytes, fileName);
}

String safeFilename(String? base) {
  return base
          ?.toLowerCase()
          .replaceAll('%', '')
          // .replaceAll('.', '')
          .replaceAll('#', '')
          .replaceAll('\$', '')
          .replaceAll('/', '')
          .replaceAll('\n', '')
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll(':', '') ??
      '';
}

about(BuildContext context) {
  showAboutDialog(
      context: context,
      applicationName: 'Multi App Viewer',
      applicationVersion: '0.0.1',
      applicationLegalese: '''Copyright 2024 Laszlo11 Kiss. All rights reserved.
    BSD3 Licence, see Licences-Multi App View
''');
}

Future<Map<String, dynamic>> readJsonFile(String? filePath,
    {BuildContext? context}) async {
  String? path;
  String? initialDirectory = !kIsWeb && Platform.isAndroid
      ? (await getApplicationDocumentsDirectory()).path
      : 'downloads';

  if (kIsWeb) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [mavFileExtension],
        initialDirectory: initialDirectory);
    if (result != null) {
      Map<String, dynamic> map =
          jsonDecode(utf8.decode(result.files.single.bytes!));
      return map;
    } else {
      return {};
    }
  }
  if (filePath == null) {
    if (Platform.isAndroid && context != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      if (context.mounted) {
        path = (await showDialog(
                context: context,
                builder: (c) {
                  return FileSelectorDialog(
                    directory: directory.path,
                  );
                }))
            .path;
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [mavFileExtension],
          initialDirectory: initialDirectory);
      if (result != null) {
        path = result.files.single.path!;
      }
    }
  }

  if (path != null) {
    var input = await File(path).readAsString();
    Map<String, dynamic> map = jsonDecode(input);
    return map;
  } else {
    return {};
  }
}

/*
https://gist.github.com/tetujin/1e57c0ebd6427cb007b5ea799a94caf8
 */
Future<String?> showTextInputDialog(BuildContext context) async {
  final textFieldController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save configuration as'),
          content: TextField(
            autofocus: true,
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "File name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context, textFieldController.text),
            ),
          ],
        );
      });
}

Future<String?> saveAsFile(String fileName, BuildContext context) async {
  String? outputFile;
  if (!kIsWeb && !Platform.isAndroid) {
    outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: fileName,
        allowedExtensions: ['mavc']);
  } else {
    outputFile = await showTextInputDialog(context);
  }
  return outputFile;
}

/*
https://davidserrano.io/working-with-files-in-flutter
*/

Color? colorOrNull(int? value) {
  return value == null ? null : Color(value);
}
