import 'package:flutter/material.dart';

import 'DuoHostController.dart';

class DuoHost extends InheritedWidget {
  final bool railActive;
  final bool fullyOpen;
  const DuoHost({
    super.key,
    required this.railActive,
    required this.fullyOpen,
    required super.child,
  });
  static DuoHost? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DuoHost>();
  @override
  bool updateShouldNotify(DuoHost oldWidget) =>
      railActive != oldWidget.railActive || fullyOpen != oldWidget.fullyOpen;

  static Widget builder(DuoHostController controller, Widget child) =>
      ListenableBuilder(
        listenable: Listenable.merge([
          controller.railActive,
          controller.fullyOpen,
        ]),
        builder: (context, _) => DuoHost(
          railActive: controller.railActive.value,
          fullyOpen: controller.fullyOpen.value,
          child: child,
        ),
      );
}
