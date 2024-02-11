import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';

import 'storage_delegate.dart';

class DashboardWidget extends StatefulWidget {
  final List<Widget> children;
  final MavFrame frame;

  ///
  const DashboardWidget(
      {super.key, required this.children, required this.frame});

  ///
  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  ///
  final ScrollController scrollController = ScrollController();
  late MavStorage mavStorage = MavStorage(widget.frame);
  DashboardItemController<MavItem>? _dashboardItemController;

  DashboardItemController<MavItem> get dashboardItemController {
    _dashboardItemController ??= DashboardItemController.withDelegate(
      itemStorageDelegate: mavStorage,
    );
    return _dashboardItemController!;
  }

  set dashboardItemController(DashboardItemController<MavItem> value) {
    _dashboardItemController = value;
    widget.frame.dashboardItemController = value;
  }

  int? slot;

  @override
  Widget build(BuildContext context) {
    // var w = MediaQuery.of(context).size.width;
    slot = 8;
    // w > 600
    //     ? w > 900
    //         ? 8
    //         : 6
    //     : 4;

    Widget dashboard = SafeArea(
      child: Dashboard<MavItem>(
        key: Key(widget.frame.id),
        shrinkToPlace: false,
        slideToTop: false,
        absorbPointer: false,
        slotBackgroundBuilder:
            SlotBackgroundBuilder.withFunction((context, item, x, y, editing) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
        padding: const EdgeInsets.all(8),
        horizontalSpace: 8,
        verticalSpace: 8,
        slotAspectRatio: 1,
        animateEverytime: true,
        dashboardItemController: dashboardItemController,
        slotCount: slot!,
        errorPlaceholder: (e, s) {
          return Text("$e , $s");
        },
        emptyPlaceholder: const Center(child: Text("Empty")),
        itemStyle: ItemStyle(
            color: Colors.transparent,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        physics: const RangeMaintainingScrollPhysics(),
        editModeSettings: EditModeSettings(
            draggableOutside: false,
            paintBackgroundLines: true,
            autoScroll: true,
            resizeCursorSide: 15,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
            backgroundStyle: const EditModeBackgroundStyle(
                lineColor: Colors.black38,
                lineWidth: 0.5,
                dualLineHorizontal: false,
                dualLineVertical: false)),
        itemBuilder: (MavItem item) {
          // var layout = item.layoutData;
          // if (item != null) {
          if (item.index >= widget.children.length) return const SizedBox();
          return Container(
              color: item.configuration.backgroundColor,
              child: widget.children[item.index]);
          // }
        },
      ),
      // ),
    );
    // need dashboardItemController.attached public
    Future.delayed(const Duration(milliseconds: 200), () {
      dashboardItemController.isEditing = widget.frame.isEditMode;
    });

    return dashboard;
  }

  @override
  void dispose() {
    // widget.frame.editModeCallback = null;
    widget.frame.dashboardItemController?.dispose();
    widget.frame.dashboardItemController = null;
    super.dispose();
  }
}
