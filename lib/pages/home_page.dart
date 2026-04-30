import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';
import '../widgets/word_card.dart';

class _WordSelectionSheet extends StatefulWidget {
  final String initialText;

  const _WordSelectionSheet({required this.initialText});

  @override
  State<_WordSelectionSheet> createState() => _WordSelectionSheetState();
}

class _WordSelectionSheetState extends State<_WordSelectionSheet> {
  final TextEditingController _textController = TextEditingController();
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _updateWords(widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateWords(String text) {
    setState(() {
      _words = text.split(RegExp(r'\W+')).where((s) => s.isNotEmpty).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the keyboard padding so input is not hidden by the keyboard
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select words to add',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Type words here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        _updateWords(_textController.text);
                      },
                      tooltip: 'Refresh word list',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _words.isEmpty
                    ? const Center(
                        child: Text(
                          'No words to display.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _words.length,
                        itemBuilder: (context, index) {
                          final word = _words[index];
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
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showWordSelectionSheet(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _WordSelectionSheet(initialText: text);
      },
    );
  }

  Future<void> _addFromClipboard(BuildContext context) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (context.mounted) {
      final clipboardText = data?.text ?? '';
      _showWordSelectionSheet(context, clipboardText);
    }
  }

  int _crossAxisCount(double width) {
    if (width < 600) return 2;       // Mobile: 2 cards
    if (width < 900) return 3;       // Tablet portrait: 3 cards
    if (width < 1200) return 4;      // Tablet landscape / small desktop: 4 cards
    return 5;                         // Large desktop: 5 cards
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flash Word Book',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, child) {
          if (provider.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${provider.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.error, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.words.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 64,
                    color: colorScheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No words added yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add words',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _crossAxisCount(constraints.maxWidth);
              
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: provider.words.length,
                itemBuilder: (context, index) {
                  return WordCard(entry: provider.words[index]);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addFromClipboard(context),
        label: const Text('Add Words'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
