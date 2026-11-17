import 'dart:io';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'JournalPhotoController.dart';

class JournalPhoto extends StatelessWidget {
  final String? path;
  final double height;
  const JournalPhoto({super.key, this.path, this.height = 180});
  @override
  Widget build(BuildContext context) {
    final controller = JournalPhotoController(path);
    final strings = AppLocalizations.of(context)!;
    Widget placeholder(String label) => Container(
      height: height,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_outlined),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: controller.hasPhoto
          ? Image.file(
              File(path!),
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: strings.entry,
              errorBuilder: (_, error, stack) =>
                  placeholder(strings.photoUnavailable),
            )
          : placeholder(strings.noPhoto),
    );
  }
}
