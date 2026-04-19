import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';
import '../widgets/word_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showWordSelectionSheet(BuildContext context, String text) {
    // Split by non-word characters and filter empty strings
    final words = text.split(RegExp(r'\W+')).where((s) => s.isNotEmpty).toList();
    
    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No words found in clipboard.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select words to add',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return ListTile(
                        title: Text(word),
                        trailing: const Icon(Icons.add),
                        onTap: () {
                          context.read<WordProvider>().addWord(word);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Adding "$word"...')),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addFromClipboard(BuildContext context) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null && data.text!.isNotEmpty) {
      if (context.mounted) {
        _showWordSelectionSheet(context, data.text!);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clipboard is empty.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Word Book'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, child) {
          if (provider.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error: ${provider.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[700], fontSize: 16),
                ),
              ),
            );
          }

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.words.isEmpty) {
            return const Center(
              child: Text('No words added yet. Tap + to add from clipboard.'),
            );
          }

          return ListView.builder(
            itemCount: provider.words.length,
            itemBuilder: (context, index) {
              return WordCard(entry: provider.words[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addFromClipboard(context),
        label: const Text('Add from Clipboard'),
        icon: const Icon(Icons.content_paste),
      ),
    );
  }
}
