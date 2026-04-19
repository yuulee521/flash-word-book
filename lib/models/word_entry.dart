class WordEntry {
  int? id;
  late String word;
  String? meaning;
  String? phonetic;
  late DateTime addedAt;

  WordEntry({
    this.id,
    required this.word,
    this.meaning,
    this.phonetic,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meaning': meaning,
      'phonetic': phonetic,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory WordEntry.fromJson(Map<String, dynamic> json, [int? id]) {
    return WordEntry(
      id: id,
      word: json['word'] as String,
      meaning: json['meaning'] as String?,
      phonetic: json['phonetic'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}
