import 'dart:async';

import 'package:dashboard/dashboard.dart';
import 'package:multi_app_viewer/multi_app_viewer.dart';

class MavStorage extends DashboardItemStorageDelegate<MavItem> {
  late MavFrame frame;

  MavStorage(this.frame);

  @override
  bool get cacheItems => false;

  @override
  FutureOr<List<MavItem>> getAllItems(int slotCount) {
    return frame.items;
  }

  @override
  bool get layoutsBySlotCount => false;

  @override
  FutureOr<void> onItemsAdded(List<dynamic> items, int slotCount) {}

  @override
  FutureOr<void> onItemsDeleted(List<dynamic> items, int slotCount) {}

  @override
  FutureOr<void> onItemsUpdated(List<dynamic> items, int slotCount) {
    for (MavItem item in items) {
      item.updateConfig();
    }
  }
}
