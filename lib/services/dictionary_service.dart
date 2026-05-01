import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DictionaryService {
  static const String _freeDictionaryBaseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  static const String _websterApiKey = String.fromEnvironment('WEBSTER_API_KEY', defaultValue: '');

  Future<Map<String, String?>> fetchWordDetails(String word) async {
    if (_websterApiKey.isNotEmpty) {
      return _fetchFromWebster(word);
    } else {
      return _fetchFromFreeDictionary(word);
    }
  }

  Future<Map<String, String?>> _fetchFromWebster(String word) async {
    try {
      final url = 'https://www.dictionaryapi.com/api/v3/references/learners/json/$word?key=$_websterApiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
          final firstEntry = data[0];

          String? phonetic;
          final hwi = firstEntry['hwi'] as Map<String, dynamic>?;
          if (hwi != null) {
            final prs = hwi['prs'] as List<dynamic>?;
            if (prs != null && prs.isNotEmpty) {
              phonetic = prs[0]['ipa'] as String?;
              if (phonetic != null) {
                phonetic = '/$phonetic/';
              }
            }
          }

          String? meaning;
          final shortdefs = firstEntry['shortdef'] as List<dynamic>?;
          if (shortdefs != null && shortdefs.isNotEmpty) {
            meaning = shortdefs[0] as String?;
          }

          return {
            'phonetic': phonetic,
            'meaning': meaning,
          };
        }
      }
    } catch (e) {
      debugPrint('Error fetching Webster dictionary data: $e');
    }
    return {
      'phonetic': null,
      'meaning': null,
    };
  }

  Future<Map<String, String?>> _fetchFromFreeDictionary(String word) async {
    try {
      final response = await http.get(Uri.parse('$_freeDictionaryBaseUrl$word'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
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
