import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import '../database/database.dart';
import '../models/word_entry.dart';
import '../services/dictionary_service.dart';

class WordProvider extends ChangeNotifier {
  Database? _db;
  final StoreRef<int, Map<String, dynamic>> _store = intMapStoreFactory.store('words_store');

  List<WordEntry> _words = [];
  bool _isLoading = true;
  String? _error;

  List<WordEntry> get words => _words;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  final DictionaryService _dictionaryService = DictionaryService();

  void setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initDb() async {
    try {
      _db = await getDatabase();
      await fetchWords();
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }

  Future<void> fetchWords() async {
    if (_db == null) return;

    _isLoading = true;
    notifyListeners();

    final finder = Finder(sortOrders: [SortOrder('addedAt', false)]);
    final records = await _store.find(_db!, finder: finder);

    _words = records.map((record) {
      return WordEntry.fromJson(record.value, record.key);
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addWord(String word) async {
    if (_db == null) return;

    final details = await _dictionaryService.fetchWordDetails(word);

    final newEntry = WordEntry(
      word: word,
      meaning: details['meaning'],
      phonetic: details['phonetic'],
      addedAt: DateTime.now(),
    );

    await _store.add(_db!, newEntry.toJson());
    
    await fetchWords();
  }

  Future<void> deleteWord(WordEntry entry) async {
    if (_db == null || entry.id == null) return;

    await _store.record(entry.id!).delete(_db!);
    await fetchWords();
  }
}
