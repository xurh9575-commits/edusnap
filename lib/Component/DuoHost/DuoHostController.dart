import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';

class DuoHostController extends NavigatorObserver {
  final key = GlobalKey<NavigatorState>();
  final railActive = ValueNotifier(false);
  final fullyOpen = ValueNotifier(false);
  StreamSubscription<String>? _back;
  StreamSubscription<DuoFoldSnapshot>? _fold;
  bool _disposed = false;
  int _request = 0;

  void start() {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    // A custom id avoids the plugin's duplicate legacy onBack callback.
    _back = ItchiDuoRail.onItemTap.listen((id) {
      if (id == 'edusnap-back') key.currentState?.maybePop();
    });
    _fold = ItchiDuoFold.snapshots.listen((snapshot) {
      if (_disposed) return;
      fullyOpen.value = snapshot.isAvailable && snapshot.wantsTwoPanes;
      refresh();
    });
    refresh();
  }

  void refresh() {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    final request = ++_request;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_disposed || request != _request) return;
      final canPop = key.currentState?.canPop() ?? false;
      final label = key.currentContext == null
          ? 'Back'
          : MaterialLocalizations.of(key.currentContext!).backButtonTooltip;
      final status = await ItchiDuoRail.setItems(
        canPop
            ? [
                ItchiRailItem.back(
                  id: 'edusnap-back',
                  accessibilityLabel: label,
                ),
              ]
            : const [],
      );
      if (!_disposed && request == _request) {
        railActive.value = canPop && status == ItchiRailStatus.available;
      }
    });
  }

  @override
  void didChangeTop(
    Route<dynamic> topRoute,
    Route<dynamic>? previousTopRoute,
  ) => refresh();

  void dispose() {
    _disposed = true;
    _back?.cancel();
    _fold?.cancel();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      ItchiDuoRail.setItems(const []);
    }
    railActive.dispose();
    fullyOpen.dispose();
  }
}
