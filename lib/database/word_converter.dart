import '../model/word.dart';

class WordConverter {
  //==================================================
  // Word → Map
  //==================================================

  static Map<String, dynamic> toMap(Word word) {
    return {
      'id': word.id,
      'language': word.language,
      'source': word.source,
      'category': word.category,
      'word': word.word,
      'meaning': word.meaning,
      'note': word.note,
      'favorite': word.favorite,
      'createTime': word.createTime.millisecondsSinceEpoch,
      'reviewCount': word.reviewCount,
      'correctCount': word.correctCount,
      'wrongCount': word.wrongCount,
    };
  }

  //==================================================
  // Map → Word
  //==================================================

  static Word fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] as int?,
      language: map['language'] as String,
      source: map['source'] as String,
      category: map['category'] as String,
      word: map['word'] as String,
      meaning: map['meaning'] as String,
      note: map['note'] as String,
      favorite: map['favorite'] as bool? ?? false,
      createTime: DateTime.fromMillisecondsSinceEpoch(
        map['createTime'] as int,
      ),
      reviewCount: map['reviewCount'] as int? ?? 0,
      correctCount: map['correctCount'] as int? ?? 0,
      wrongCount: map['wrongCount'] as int? ?? 0,
    );
  }
}