import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class AppDatabase {
  //==================================================
  // Database 設定
  //==================================================

  static const String databaseName = 'word_database';

  static const int databaseVersion = 1;

  static const String wordStoreName = 'words';

  //==================================================
  // Database instance
  //==================================================

  static Database? _database;

  //==================================================
  // 取得 Database
  //==================================================

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();

    return _database!;
  }

  //==================================================
  // 開啟 Database
  //==================================================

  static Future<Database> _openDatabase() async {
    final factory = getIdbFactory();

    if (factory == null) {
      throw Exception(
        'IndexedDB is not supported.',
      );
    }

    return await factory.open(
      databaseName,
      version: databaseVersion,

      onUpgradeNeeded: (
        VersionChangeEvent event,
      ) {
        final db = event.database;

        final oldVersion =
            event.oldVersion;

        final newVersion =
            event.newVersion;

        print(
          'Database upgrade: '
          '$oldVersion → $newVersion',
        );

        //--------------------------------------------------
        // Version 1
        //--------------------------------------------------

        if (oldVersion < 1) {
          if (!db.objectStoreNames
              .contains(wordStoreName)) {
            db.createObjectStore(
              wordStoreName,
              keyPath: 'id',
              autoIncrement: true,
            );
          }
        }
      },
    );
  }

  //==================================================
  // CREATE
  //==================================================

  static Future<int> addWord(
    Map<String, dynamic> data,
  ) async {
    final db = await database;

    final txn = db.transaction(
      wordStoreName,
      idbModeReadWrite,
    );

    final store = txn.objectStore(
      wordStoreName,
    );

    // 新增資料時，不要把 id:null 傳給 IndexedDB
    final dataWithoutId = Map<String, dynamic>.from(data);

    dataWithoutId.remove('id');

    final key = await store.add(
      dataWithoutId,
    );

    await txn.completed;

    return key as int;
  }

  //==================================================
  // READ ALL
  //==================================================

  static Future<List<Map<String, dynamic>>> getAllWords() async {
    final db = await database;

    final txn = db.transaction(
      wordStoreName,
      idbModeReadOnly,
    );

    final store = txn.objectStore(
      wordStoreName,
    );

    final result = await store.getAll();

    await txn.completed;

    return result
        .map(
          (item) => Map<String, dynamic>.from(
            item as Map,
          ),
        )
        .toList();
  }

  //==================================================
  // READ ONE
  //==================================================

  static Future<Map<String, dynamic>?> getWord(
    int id,
  ) async {
    final db = await database;

    final txn = db.transaction(
      wordStoreName,
      idbModeReadOnly,
    );

    final store = txn.objectStore(
      wordStoreName,
    );

    final result = await store.getObject(id);

    await txn.completed;

    if (result == null) {
      return null;
    }

    return Map<String, dynamic>.from(
      result as Map,
    );
  }

  //==================================================
  // UPDATE
  //==================================================

  static Future<void> updateWord(
    Map<String, dynamic> data,
  ) async {
    final db = await database;

    final txn = db.transaction(
      wordStoreName,
      idbModeReadWrite,
    );

    final store = txn.objectStore(
      wordStoreName,
    );

    await store.put(data);

    await txn.completed;
  }

  //==================================================
  // DELETE
  //==================================================

  static Future<void> deleteWord(
    int id,
  ) async {
    final db = await database;

    final txn = db.transaction(
      wordStoreName,
      idbModeReadWrite,
    );

    final store = txn.objectStore(
      wordStoreName,
    );

    await store.delete(id);

    await txn.completed;
  }

  //==================================================
  // DELETE ALL
  //==================================================

  static Future<void> deleteAllWords() async {

    final db = await database;

    final txn = db.transaction(
      wordStoreName,
      idbModeReadWrite,
    );

    final store = txn.objectStore(
      wordStoreName,
    );

    await store.clear();

    await txn.completed;
  }

  //==================================================
  // CREATE WITH ID
  //==================================================

  static Future<void> addWordWithId(
    Map<String, dynamic> data,
  ) async {

    final db = await database;

    final txn = db.transaction(
      wordStoreName,
      idbModeReadWrite,
    );

    final store = txn.objectStore(
      wordStoreName,
    );

    await store.put(data);

    await txn.completed;
  }

  //==================================================
  // TEST
  //==================================================

  static Future<void> testDatabase() async {
    final db = await database;

    print(
      'Database opened: ${db.name}',
    );

    print(
      'Database version: ${db.version}',
    );
  }
}