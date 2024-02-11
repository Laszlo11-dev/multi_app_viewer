import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveFilePlatform(var bytes, String fileName) async {
  String directoryPath = fileName;

  if (!fileName.contains('\\')) {
    if (Platform.isIOS || Platform.isWindows || Platform.isAndroid) {
      directoryPath = (await getApplicationDocumentsDirectory()).path;
    } else {
      // directoryPath = '/storage/emulated/0/Download';
      // if (!await Directory('/storage/emulated/0/Download').exists()) {
      directoryPath = (await getDownloadsDirectory())!.path;
      // }
    }
    directoryPath = '$directoryPath/$fileName';
  }
  if (bytes != null) {
    File imgFile = File(directoryPath);
    if (bytes is String) {
      await imgFile.writeAsString(bytes);
    } else {
      await imgFile.writeAsBytes(bytes);
    }
  }
  return directoryPath;
}
