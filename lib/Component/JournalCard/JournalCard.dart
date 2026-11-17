import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Models/JournalEntry.dart';
import '../../l10n/app_localizations.dart';
import '../JournalPhoto/JournalPhoto.dart';
import 'JournalCardController.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;
  const JournalCard({super.key, required this.entry, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final controller = JournalCardController(entry);
    final s = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JournalPhoto(path: entry.photoPath, height: 120),
              const SizedBox(height: 12),
              Text(
                entry.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                controller.hasNote ? entry.note : s.noNote,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                s.createdOn(
                  DateFormat.yMMMd(s.localeName).format(entry.createdAt),
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
