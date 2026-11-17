import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import 'JournalCardController.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;
  const JournalCard({super.key, required this.entry, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final controller = JournalCardController(entry);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        title: Text(entry.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                controller.date,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
