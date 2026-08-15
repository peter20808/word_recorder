import 'dart:convert';
import 'dart:html' as html;

import '../data/word_database.dart';
import '../model/word.dart';

import 'app_database.dart';
import 'word_converter.dart';

class BackupService {

  //==================================================
  // Backup Version
  //==================================================

  static const int backupVersion = 1;


  //==================================================
  // Export
  //==================================================

  static Future<void> exportWords() async {

    final words = WordDatabase.words;

    final data = {
      'version': backupVersion,

      'exportTime':
          DateTime.now().toIso8601String(),

      'words': words
          .map(
            (word) => WordConverter.toMap(word),
          )
          .toList(),
    };

    final jsonString =
        const JsonEncoder.withIndent('  ')
            .convert(data);

    final blob = html.Blob(
      [jsonString],
      'application/json',
    );

    final url =
        html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute(
        'download',
        'word_backup.json',
      )
      ..click();

    html.Url.revokeObjectUrl(url);
  }


  //==================================================
  // Import：選擇 JSON 檔案
  //==================================================

  static Future<String?> pickBackupFile() async {

    final input =
        html.FileUploadInputElement();

    input.accept =
        '.json,application/json';

    input.click();

    await input.onChange.first;

    if (input.files == null ||
        input.files!.isEmpty) {
      return null;
    }

    final file = input.files!.first;

    final reader = html.FileReader();

    reader.readAsText(file);

    await reader.onLoad.first;

    return reader.result as String;
  }


  //==================================================
  // Import：解析與驗證 Backup
  //==================================================

  static Future<List<Word>> importBackup(
    String jsonString,
  ) async {

    //--------------------------------------------------
    // JSON Decode
    //--------------------------------------------------

    dynamic decoded;

    try {
      decoded = jsonDecode(jsonString);
    } catch (e) {
      throw Exception(
        "備份檔不是有效的 JSON 格式",
      );
    }

    //--------------------------------------------------
    // Root 必須是 Map
    //--------------------------------------------------

    if (decoded is! Map) {
      throw Exception(
        "備份檔格式錯誤",
      );
    }

    final data =
        Map<String, dynamic>.from(decoded);

    //--------------------------------------------------
    // Version
    //--------------------------------------------------

    if (!data.containsKey('version')) {
      throw Exception(
        "備份檔缺少 version",
      );
    }

    final version =
        data['version'];

    if (version is! int) {
      throw Exception(
        "備份檔 version 格式錯誤",
      );
    }

    if (version != backupVersion) {
      throw Exception(
        "不支援的備份版本：$version",
      );
    }

    //--------------------------------------------------
    // Words
    //--------------------------------------------------

    if (!data.containsKey('words')) {
      throw Exception(
        "備份檔缺少 words",
      );
    }

    if (data['words'] is! List) {
      throw Exception(
        "備份檔 words 格式錯誤",
      );
    }

    final wordsData =
        data['words'] as List;

    //--------------------------------------------------
    // Map → Word
    //--------------------------------------------------

    final List<Word> words = [];

    for (
      int i = 0;
      i < wordsData.length;
      i++
    ) {

      final item =
          wordsData[i];

      if (item is! Map) {
        throw Exception(
          "第 ${i + 1} 筆單字資料格式錯誤",
        );
      }

      try {

        final map =
            Map<String, dynamic>.from(item);

        final word =
            WordConverter.fromMap(map);

        words.add(word);

      } catch (e) {

        throw Exception(
          "第 ${i + 1} 筆單字資料無法讀取：$e",
        );
      }
    }

    return words;
  }

  //==================================================
  // Import：覆蓋目前資料
  //==================================================

  static Future<void> overwriteWords(
    List<Word> words,
  ) async {

    //--------------------------------------------------
    // 先清除目前 IndexedDB
    //--------------------------------------------------

    await AppDatabase.deleteAllWords();

    //--------------------------------------------------
    // 寫入備份資料
    //--------------------------------------------------

    for (final word in words) {

      final data =
          WordConverter.toMap(word);

      await AppDatabase.addWordWithId(
        data,
      );
    }
  }


  //==================================================
  // Import：合併目前資料
  //==================================================

  static Future<void> mergeWords(
    List<Word> importedWords,
  ) async {

    //--------------------------------------------------
    // 取得目前資料
    //--------------------------------------------------

    final currentWords =
        await AppDatabase.getAllWords();

    //--------------------------------------------------
    // 找目前最大的 ID
    //--------------------------------------------------

    int maxId = 0;

    for (final data in currentWords) {

      final id = data['id'];

      if (id is int && id > maxId) {
        maxId = id;
      }
    }

    //--------------------------------------------------
    // 從 maxId + 1 開始
    //--------------------------------------------------

    int nextId = maxId + 1;

    //--------------------------------------------------
    // 寫入匯入資料
    //--------------------------------------------------

    for (final word in importedWords) {

      final data =
          WordConverter.toMap(word);

      //------------------------------------------------
      // 使用新的 ID
      //------------------------------------------------

      data['id'] = nextId;

      await AppDatabase.addWordWithId(
        data,
      );

      nextId++;
    }
  }

  //==================================================
  // Import：直接建立資料
  //==================================================

  static Future<void> importWordsDirectly(
    List<Word> words,
  ) async {

    for (final word in words) {

      final data =
          WordConverter.toMap(word);

      await AppDatabase.addWordWithId(
        data,
      );
    }
  }
  
}