import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../util/extensions.dart';
import 'main_toolbar.dart';

import 'item_widget.dart';
import '../util/screen_recorder.dart';
import '../util/util.dart';

import '../../multi_app_viewer.dart';
import '../dialog/item_config_dialog.dart';
import '../dialog/frame_config_dialog.dart';
import '../util/layout_builder.dart';
import 'tilt_widget.dart';

/// Signature of customizable item builder function
///
typedef ItemBuilder = Widget Function(MavItem item);

/// See sample project for details
/// Wrap your top level widget inside [MavFrameWidget]
/// [itemBuilder]

class MavFrameWidget extends StatefulWidget {
  final ItemBuilder itemBuilder;

  // final LayoutBuilderType? layoutBuilder;
  // final MavFrame mavFrame;

  const MavFrameWidget({
    super.key,
    required this.itemBuilder,
    // this.layoutBuilder,
    // required this.mavFrame,
  });

  @override
  State<MavFrameWidget> createState() => _MavFrameWidgetState();
}

class _MavFrameWidgetState extends State<MavFrameWidget> {
  late ScreenRecorderController controller =
      ScreenRecorderController(pixelRatio: 1, skipFramesBetweenCaptures: 1);
  late GlobalKey previewContainer = controller.containerKey;
  ValueNotifier<bool> isRecordingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    if (MavFrame.autoRunScript.isNotEmpty) {
      mainNotifier.value.runScript(MavFrame.autoRunScript);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MavFrame>(
        valueListenable: mainNotifier,
        builder: (c, frameConfig, w) {
          final Color iconColor =
              (frameConfig.frameConfiguration.backgroundColor ?? Colors.white)
                  .onThis();
          previewContainer = controller.containerKey;
          return SafeArea(
            key: Key(frameConfig.id),
            child: Scaffold(
              appBar: frameConfig.isToolbarHidden
                  ? PreferredSize(
                      preferredSize: const Size(20, 40),
                      child: Container(
                        color: frameConfig.frameConfiguration.backgroundColor,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                frameConfig.toggleToolbar();
                              },
                              tooltip: 'Show app bar',
                              icon: const Icon(Icons.chevron_left)),
                        ),
                      ),
                    )
                  : AppBar(
                      backgroundColor:
                          frameConfig.frameConfiguration.backgroundColor,
                      title: GestureDetector(
                          onDoubleTap: () {
                            frameConfig.toggleToolbar();
                          },
                          child: Text(
                            'Multi App Viewer',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: iconColor),
                          )),
                      actions: [
                        if (frameConfig.isRunning)
                          IconButton(
                              onPressed: () {
                                frameConfig.animatePreferredList();
                              },
                              tooltip:
                                  'Start/stop animation of preferred configs',
                              icon: frameConfig.isRunning
                                  ? const Icon(
                                      Icons.stop,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.start,
                                      color: iconColor,
                                    )),
                        ValueListenableBuilder(
                          valueListenable: isRecordingNotifier,
                          builder: (BuildContext context, bool isRecording,
                              Widget? child) {
                            return IconButton(
                                onPressed: () async {
                                  if (isRecording) {
                                    controller.stop();
                                    recordScreen(context, controller);
                                    isRecordingNotifier.value = false;
                                  } else {
                                    controller.start();
                                    isRecordingNotifier.value = true;
                                  }
                                },
                                tooltip: 'Screen capture start/stop',
                                icon: isRecording
                                    ? const Icon(Icons.stop, color: Colors.red)
                                    : Icon(
                                        Icons.emergency_recording,
                                        color: iconColor,
                                      ));
                          },
                        ),
                        if (frameConfig.isEditMode)
                          IconButton(
                              onPressed: () {
                                add(context, mavFrame: frameConfig);
                              },
                              tooltip: 'Add new instance',
                              icon: const Icon(Icons.add)),
                        if (frameConfig.frameConfiguration.isTiltMode &&
                            frameConfig.frameConfiguration.isEditMode)
                          IconButton(
                              onPressed: () {
                                frameConfig.frameConfiguration.resetTilt();
                                frameConfig.update();
                              },
                              tooltip: 'Reset tilt',
                              icon: const Icon(
                                Icons.align_vertical_bottom,
                              )),
                        if (frameConfig.frameConfiguration.isEditMode)
                          IconButton(
                              onPressed: () {
                                frameConfig.frameConfiguration.isTiltMode =
                                    !frameConfig.frameConfiguration.isTiltMode;
                                frameConfig.update();
                              },
                              tooltip: '3d tilt mode on/off',
                              icon: Icon(
                                Icons.threed_rotation,
                                color: frameConfig.frameConfiguration.isTiltMode
                                    ? Colors.red
                                    : iconColor,
                              )),
                        IconButton(
                            onPressed: () {
                              frameConfig.isEditMode = !frameConfig.isEditMode;
                              frameConfig.update();
                            },
                            tooltip: 'Edit mode on/off',
                            icon: Icon(
                              Icons.edit,
                              color: frameConfig.isEditMode
                                  ? Colors.red
                                  : iconColor,
                            )),
                        PopupMenuButton<FrameConfiguration>(
                          tooltip: 'Preferred list',
                          offset: const Offset(0, 32),
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            color: iconColor,
                          ),
                          onSelected: (FrameConfiguration config) {
                            MavFrame.loadConfiguration(config);
                          },
                          itemBuilder: (BuildContext context) => MavFrame
                              .preferredList
                              .map(
                                (e) => PopupMenuItem(
                                  value: e,
                                  child: Text((e.name ?? e.title) ?? 'NoTitle'),
                                ),
                              )
                              .toList(),
                        ),
                        MainToolbar(
                          frameConfig: frameConfig,
                          previewContainer: previewContainer,
                        ),
                        IconButton(
                            onPressed: () {
                              frameConfig.toggleToolbar();
                            },
                            tooltip: 'Hide app bar',
                            icon: Icon(Icons.chevron_right, color: iconColor)),
                      ],
                    ),
              body: RepaintBoundary(
                key: previewContainer,
                child: AnimatedSwitcher(
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  duration: const Duration(milliseconds: 600),
                  child: ColoredBox(
                    key: Key(frameConfig.id),
                    color: frameConfig.frameConfiguration.backgroundColor ??
                        Colors.transparent,
                    child: GestureDetector(
                      onTap: frameConfig.isEditMode
                          ? () {
                              frameEdit(context, mavFrame: frameConfig);
                            }
                          : null,
                      child: Tilt(
                        key: Key(frameConfig.id),
                        frame: frameConfig,
                        child: Column(
                          children: [
                            if (frameConfig
                                    .frameConfiguration.title?.isNotEmpty ??
                                false)
                              Html(
                                key: Key(frameConfig.frameConfiguration.title!),
                                shrinkWrap: true,
                                data: frameConfig.frameConfiguration.title,
                                style: const {},
                              ),
                            Expanded(
                              child: Center(
                                  child: Container(
                                padding: frameConfig.frameConfiguration.title
                                            ?.isNotEmpty ??
                                        false
                                    ? const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16)
                                    : const EdgeInsets.all(16),
                                color: frameConfig
                                        .frameConfiguration.backgroundColor ??
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: ( //widget.layoutBuilder ??
                                    getLayout(frameConfig
                                            .frameConfiguration.layoutType) ??
                                        frameLayoutColumn)(
                                  frame: frameConfig,
                                  children: [
                                    for (MavItem item in frameConfig.items)
                                      ItemWidget(
                                        key: Key(item.identifier),
                                        item: item,
                                        itemBuilder: widget.itemBuilder,
                                      )
                                  ],
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> add(BuildContext context,
      {ItemConfiguration? configuration, required MavFrame mavFrame}) async {
    await showDialog(
        context: context,
        builder: (c) {
          return ItemConfigDialog(
            frame: mavFrame,
            isNew: configuration == null,
            configuration:
                configuration ?? ItemConfiguration(title: 'New', id: ''),
          );
        });
  }

  Future<void> frameEdit(BuildContext context,
      {required MavFrame mavFrame}) async {
    await showDialog(
        context: context,
        builder: (c) {
          return FrameConfigDialog(
            frame: mavFrame,
          );
        });
  }
}
