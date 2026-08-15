import '../model/word.dart';
import '../database/app_database.dart';
import '../database/word_converter.dart';

class WordDatabase {
  //==================================================
  // Memory Cache
  //==================================================

  static List<Word> words = [];

  //==================================================
  // 初始化
  //==================================================

  static Future<void> initialize() async {
    final dataList =
        await AppDatabase.getAllWords();

    final loadedWords = dataList
        .map(
          (data) => WordConverter.fromMap(data),
        )
        .toList();

    words = loadedWords;
  }

  //==================================================
  // 新增
  //==================================================

  static Future<void> addWord(
    Word word,
  ) async {
    final data =
        WordConverter.toMap(word);

    final id =
        await AppDatabase.addWord(data);

    word.id = id;

    words.add(word);
  }

  //==================================================
  // 刪除
  //==================================================

  static Future<void> removeWord(
    Word word,
  ) async {
    if (word.id == null) {
      return;
    }

    await AppDatabase.deleteWord(
      word.id!,
    );

    words.remove(word);
  }

  //==================================================
  // 修改
  //==================================================

  static Future<void> updateWord(
    Word oldWord,
    Word newWord,
  ) async {
    if (oldWord.id == null) {
      return;
    }

    // 保留原本 ID
    newWord.id = oldWord.id;

    // 保留原本建立時間
    newWord.createTime =
        oldWord.createTime;

    final data =
        WordConverter.toMap(newWord);

    await AppDatabase.updateWord(
      data,
    );

    final index =
        words.indexOf(oldWord);

    if (index != -1) {
      words[index] = newWord;
    }
  }
}