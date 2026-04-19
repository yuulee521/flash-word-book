import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DictionaryService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

  Future<Map<String, String?>> fetchWordDetails(String word) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$word'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final firstEntry = data[0];
          final phonetic = firstEntry['phonetic'] as String?;
          
          String? meaning;
          final meanings = firstEntry['meanings'] as List<dynamic>?;
          if (meanings != null && meanings.isNotEmpty) {
            final definitions = meanings[0]['definitions'] as List<dynamic>?;
            if (definitions != null && definitions.isNotEmpty) {
              meaning = definitions[0]['definition'] as String?;
            }
          }
          
          return {
            'phonetic': phonetic,
            'meaning': meaning,
          };
        }
      }
    } catch (e) {
      debugPrint('Error fetching dictionary data: $e');
    }
    return {
      'phonetic': null,
      'meaning': null,
    };
  }
}
