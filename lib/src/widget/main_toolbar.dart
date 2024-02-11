import 'package:flutter/material.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';
import 'package:multi_app_viewer/src/util/extensions.dart';
import '../util/util.dart';
import 'responsive_toolbar.dart';

class MainToolbar extends StatelessWidget {
  final MavFrame frameConfig;
  final GlobalKey previewContainer;

  const MainToolbar(
      {super.key, required this.frameConfig, required this.previewContainer});

  @override
  Widget build(BuildContext context) {
    return ResponsiveToolbar(
        maxWidth: 60,
        // backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
        //     Theme.of(context).primaryColor,
        // foregroundColor: (Theme.of(context).appBarTheme.backgroundColor ??
        //         Theme.of(context).primaryColor)
        //     .onThis(),
        items: [
          ToolbarItem(
            icon: frameConfig.isRunning ? Icons.stop : Icons.start,
            caption: 'Run script',
            onPressed: () {
              if (MavFrame.buttonScript.hasItem()) {
                frameConfig.runScript(MavFrame.buttonScript);
              }
            },
            isSelected: frameConfig.isRunning,
          ),
          ToolbarItem(
            onPressed: () {
              frameConfig.frameConfiguration.isFullScreen =
                  !frameConfig.frameConfiguration.isFullScreen;
              if (frameConfig.frameConfiguration.isFullScreen) {
                FullScreenWindow.setFullScreen(true);
                // goFullScreen();
              } else {
                FullScreenWindow.setFullScreen(false);
                // exitFullScreen();
              }
            },
            caption: 'Full screen on/off',
            icon: Icons.fullscreen,
          ),
          ToolbarItem(
            caption: 'Screenshot of the internal area',
            icon: Icons.screenshot,
            onPressed: () async {
              takeScreenShot(context, previewContainer);
            },
          ),
          ToolbarItem(
            icon: Icons.file_open_outlined,
            caption: 'Load config',
            onPressed: () async {
              var ize = await readJsonFile(null, context: context);
              if (ize.isNotEmpty) {
                frame.frameConfiguration = FrameConfiguration.fromJson(ize);
                frame.update();
              }
            },
          ),
          ToolbarItem(
            icon: Icons.save,
            caption: 'Save config',
            onPressed: () async {
              var result = await saveAsFile('mav_config', context);
              if (result != null) {
                saveFile(frameConfig.jsonString(), '$result.$mavFileExtension');
              }
            },
          ),
          ToolbarItem(
            caption: 'About',
            icon: Icons.help,
            onPressed: () {
              about(context);
            },
          ),
        ]);
  }
}
