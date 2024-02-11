import 'package:flutter/material.dart';
import 'dart:io' as io;

/*
https://stackoverflow.com/questions/50521274/how-to-get-a-list-of-files-from-the-directory-and-pass-it-to-the-listview
 */

class FileSelectorDialog<FileSystemEntity> extends StatefulWidget {
  final String directory;

  const FileSelectorDialog({super.key, required this.directory});

  @override
  State<FileSelectorDialog> createState() => _FileSelectorDialogState();
}

class _FileSelectorDialogState extends State<FileSelectorDialog> {
  List<io.FileSystemEntity> fileList = [];

  @override
  void initState() {
    super.initState();
    _listOfFiles();
  }

  void _listOfFiles() async {
    setState(() {
      fileList = io.Directory(widget.directory)
          .listSync()
          .where((element) => element.path.toLowerCase().endsWith('mavc'))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Double click file to select'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                    itemCount: fileList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onDoubleTap: () {
                            Navigator.of(context).pop(fileList[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(fileList[index].path),
                          ));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
