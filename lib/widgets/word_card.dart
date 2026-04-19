import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/word_entry.dart';
import '../providers/word_provider.dart';
import 'package:provider/provider.dart';

class WordCard extends StatelessWidget {
  final WordEntry entry;

  const WordCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text(
          entry.word,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.phonetic != null)
              Text(
                entry.phonetic!,
                style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
              ),
            Text(
              'Added on: ${DateFormat('yyyy-MM-dd HH:mm').format(entry.addedAt)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meaning:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(entry.meaning ?? 'No definition found.'),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<WordProvider>().deleteWord(entry);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
