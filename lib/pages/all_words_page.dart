import 'package:flutter/material.dart';

import '../data/word_database.dart';

import '../model/word.dart';

import '../widgets/status_bar.dart';
import '../widgets/word_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/search_bar.dart';

import '../pages/word_detail_page.dart';

import '../database/backup_service.dart';
import '../database/app_database.dart';
import '../database/word_converter.dart';

import 'home_page.dart';
import 'add_word_page.dart';
import '../components/app_menu.dart';

class AllWordsPage extends StatefulWidget {
  const AllWordsPage({super.key});

  @override
  State<AllWordsPage> createState() => _AllWordsPageState();
}

class _AllWordsPageState extends State<AllWordsPage> {
  final TextEditingController searchController = TextEditingController();

  List<Word> filteredWords = [];

  String selectedLanguage = "All";
  String selectedSource = "All";
  String selectedCategory = "All";
  String selectedFavorite = "All";

  bool _isCheckingImport = true;

  List<String> get languages {
    final result = WordDatabase.words
        .map((word) => word.language)
        .toSet()
        .toList();

    result.sort();

    return ["All", ...result];
  }

  final List<String> categories = [
    "All",
    "一般",
    "稱呼",
    "階級",
    "文法",
    "片語",
    "例句",
    "慣用語",
    "其他",
  ];

  List<String> get sources {
    final result = WordDatabase.words
        .map((word) => word.source)
        .toSet()
        .toList();

    result.sort();

    return ["All", ...result];
  }

  final List<String> favoriteOptions = [
    "All",
    "Favorites",
    "Unfavorite",
  ];

  @override
  void initState() {
    super.initState();

    filteredWords =
        List.from(
      WordDatabase.words,
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _checkEmptyDatabase();
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Word> words = WordDatabase.words;

    return Scaffold(
      appBar: AppBar(
        title: const Text("所有單字"),

        actions: [

          //--------------------------------------------------
          // 匯入
          //--------------------------------------------------

          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: "匯入單字",
            onPressed: _importWords,
          ),

          //--------------------------------------------------
          // 匯出
          //--------------------------------------------------

          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "匯出單字",
            onPressed: _exportWords,
          ),

          //切換畫面
          AppMenu(
            onSelected: (item) {
              switch (item) {
                case AppMenuItem.home:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                );
                break;

                case AppMenuItem.addWord:
                  Navigator.pushReplacement(
                    context,
                      MaterialPageRoute(
                        builder: (context) => const AddWordPage(),
                      ),
                    );
                    break;

                case AppMenuItem.allWords:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllWordsPage(),
                    ),
                );
                break;
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [

          //--------------------------------------------------
          // Status Bar
          //--------------------------------------------------

          StatusBar(
            language: "全部",
            source: "",
            word: "共 ${filteredWords.length} 筆",
          ),

          const SizedBox(height: 10),


          //--------------------------------------------------
          //  Filter
          //--------------------------------------------------
          Row(
            children: [
              const SizedBox(width: 8),

              DropdownButton<String>(
                value: selectedLanguage,

                items: languages.map((language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedLanguage = value;
                  });

                  _applyFilter();
                },
              ),

              const SizedBox(width: 8),

              DropdownButton<String>(
                value: selectedSource,

                items: sources.map((source) {
                  return DropdownMenuItem<String>(
                    value: source,
                    child: Text(source),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedSource = value;
                  });

                  _applyFilter();
                },
              ),

              const SizedBox(width: 8),

              DropdownButton<String>(
                value: selectedCategory,

                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedCategory = value;
                  });

                  _applyFilter();
                },
              ),

              const SizedBox(width: 8),

              DropdownButton<String>(
                value: selectedFavorite,

                items: favoriteOptions.map((favorite) {
                  return DropdownMenuItem<String>(
                    value: favorite,
                    child: Text(favorite),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedFavorite = value;
                  });

                  _applyFilter();
                },
              ),
            ],
          ),

          TextButton.icon(
            onPressed: _hasActiveFilter
              ? _clearFilters
              : null,
            icon: const Icon(Icons.clear),
            label: const Text("清除篩選"),
          ),

          //--------------------------------------------------
          // Search
          //--------------------------------------------------

          const SizedBox(height: 8),

          WordSearchBar(
            controller: searchController,
            onChanged: _search,
          ),

          const SizedBox(height: 16),


          //--------------------------------------------------
          // Word List
          //--------------------------------------------------

          Expanded(
            child: words.isEmpty
                ? const EmptyView(
                    message: "目前尚未新增任何單字",
                    description: "請到「新增單字」開始建立第一筆資料。",
                  )
                : filteredWords.isEmpty
                    ? const EmptyView(
                        message: "沒有符合的單字",
                        description: "請嘗試調整搜尋文字或篩選條件。",
                      )
                : ListView.builder(
                    itemCount: filteredWords.length,

                    itemBuilder: (context, index) {
                      return WordCard(
                        word: filteredWords[index],

                        onTap: () {
                          _openWordDetail(
                            filteredWords[index],
                          );
                        },

                        onFavoriteChanged: () {
                          _toggleFavorite(
                            filteredWords[index],
                          );
                        },

                        onDelete: () {
                          _deleteWord(
                            filteredWords[index],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(Word word) async {
    final newWord = Word(
      id: word.id,
      language: word.language,
      source: word.source,
      category: word.category,
      word: word.word,
      meaning: word.meaning,
      note: word.note,
      favorite: !word.favorite,
      createTime: word.createTime,
      reviewCount: word.reviewCount,
      correctCount: word.correctCount,
      wrongCount: word.wrongCount,
    );

    await WordDatabase.updateWord(
      word,
      newWord,
    );

    final index = filteredWords.indexOf(word);
    if (index != -1) {
      setState(() {
          filteredWords[index] = newWord;
      });
    }
  }

  Future<void> _deleteWord(Word word) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('刪除單字'),
          content: Text(
            '確定要刪除「${word.word}」嗎？',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('刪除'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await WordDatabase.removeWord(word);

    setState(() {
      filteredWords.remove(word);
    });
  }

  //--------------------------------------------------
  // Search
  //--------------------------------------------------

  void _search(String keyword) {
    _applyFilter();
  }

  //--------------------------------------------------
  // Search + Language Filter
  //--------------------------------------------------

  void _applyFilter() {
    final keyword = searchController.text.trim().toLowerCase();

    setState(() {
      filteredWords = WordDatabase.words.where((word) {

        // Language Filter
        final matchLanguage =
            selectedLanguage == "All" ||
            word.language == selectedLanguage;

        // Source Filter
        final matchSource =
            selectedSource == "All" ||
            word.source == selectedSource;

        // Category Filter
        final matchCategory =
            selectedCategory == "All" ||
            word.category == selectedCategory;

        // Search Filter
        final matchSearch =
            keyword.isEmpty ||
            word.word.toLowerCase().contains(keyword) ||
            word.meaning.toLowerCase().contains(keyword) ||
            word.note.toLowerCase().contains(keyword);

        // Search Favorite
        final matchFavorite =
            selectedFavorite == "All" ||
            (selectedFavorite == "Favorites" &&
                word.favorite) ||
            (selectedFavorite == "Unfavorite" &&
                !word.favorite);

        return matchLanguage &&
            matchSource &&
            matchCategory &&
            matchFavorite &&
            matchSearch;
      }).toList();
    });
  }

  bool get _hasActiveFilter {
    return searchController.text.trim().isNotEmpty ||
        selectedLanguage != "All" ||
        selectedSource != "All" ||
        selectedCategory != "All" ||
        selectedFavorite != "All";
  }

  void _clearFilters() {
    setState(() {
      searchController.clear();

      selectedLanguage = "All";
      selectedSource = "All";
      selectedCategory = "All";
      selectedFavorite = "All";
      filteredWords = List.from(
        WordDatabase.words,
      );
    });
  }

  //--------------------------------------------------
  // Open Word Detail
  //--------------------------------------------------

  Future<void> _openWordDetail(Word word) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordDetailPage(
          word: word,
        ),
      ),
    );

    _refresh();
  }

  //--------------------------------------------------
  // Refresh
  //--------------------------------------------------

  void _refresh() {
    _applyFilter();
  }



  Future<void> _exportWords() async {
    try {
      await BackupService.exportWords();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("單字備份成功"),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("備份失敗：$e"),
        ),
      );
    }
  }

  Future<void> _importWords({
    bool firstImport = false,
  }) async {
    try {
      //--------------------------------------------------
      // 選擇檔案
      //--------------------------------------------------
      final jsonString =
          await BackupService.pickBackupFile();

      if (jsonString == null) {
        return;
      }

      //--------------------------------------------------
      // 解析與驗證
      //--------------------------------------------------

      final importedWords =
          await BackupService.importBackup(
        jsonString,
      );

      //--------------------------------------------------
      // 詢問匯入方式
      //--------------------------------------------------

      if (!mounted) return;

      final result =
          await showDialog<String>(
        context: context,
        builder: (context) {

          return AlertDialog(

            title: const Text(
              "匯入單字",
            ),

            content: Text(
              "備份檔共有 ${importedWords.length} 筆單字。\n\n"
              "請選擇匯入方式。",
            ),

            actions: [

              //------------------------------------------------
              // 取消
              //------------------------------------------------

              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    'cancel',
                  );
                },
                child: const Text(
                  "取消",
                ),
              ),

              //------------------------------------------------
              // 覆蓋
              //------------------------------------------------

              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    'overwrite',
                  );
                },
                child: const Text(
                  "覆蓋",
                ),
              ),

              //------------------------------------------------
              // 合併
              //------------------------------------------------

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    'merge',
                  );
                },
                child: const Text(
                  "合併",
                ),
              ),
            ],
          );
        },
      );

      //--------------------------------------------------
      // 取消
      //--------------------------------------------------

      if (result == null ||
          result == 'cancel') {
        return;
      }

      //--------------------------------------------------
      // 覆蓋
      //--------------------------------------------------

      if (result == 'overwrite') {

        await BackupService.overwriteWords(
          importedWords,
        );

        await _reloadWords();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "單字資料已覆蓋",
            ),
          ),
        );

        return;
      }

      //--------------------------------------------------
      // 合併
      //--------------------------------------------------

      if (result == 'merge') {

        await BackupService.mergeWords(
          importedWords,
        );

        await _reloadWords();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "單字資料合併成功",
            ),
          ),
        );

        return;
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "匯入失敗：$e",
          ),
        ),
      );
    }
  }

  Future<void> _reloadWords() async {

    final words =
        await AppDatabase.getAllWords();

    setState(() {

      WordDatabase.words =
          words
              .map(
                (data) =>
                    WordConverter.fromMap(data),
              )
              .toList();

      filteredWords =
          List.from(
        WordDatabase.words,
      );

    });
  }

  Future<void> _checkEmptyDatabase() async {

    //--------------------------------------------------
    // 已經有資料
    //--------------------------------------------------

    if (WordDatabase.words.isNotEmpty) {

      setState(() {
        _isCheckingImport = false;
      });

      return;
    }

    //--------------------------------------------------
    // 沒有資料
    //--------------------------------------------------

    if (!mounted) return;

    final result =
        await showDialog<String>(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text(
            "目前沒有單字資料",
          ),

          content: const Text(
            "目前找不到已保存的單字資料。\n\n"
            "是否要從備份檔匯入單字？",
          ),

          actions: [

            //------------------------------------------------
            // 取消
            //------------------------------------------------

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  'cancel',
                );
              },
              child: const Text(
                "取消",
              ),
            ),

            //------------------------------------------------
            // 匯入
            //------------------------------------------------

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  'import',
                );
              },
              child: const Text(
                "匯入資料",
              ),
            ),
          ],
        );
      },
    );

    //--------------------------------------------------
    // 使用者取消
    //--------------------------------------------------

    if (result != 'import') {

      if (!mounted) return;

      setState(() {
        _isCheckingImport = false;
      });

      return;
    }

    //--------------------------------------------------
    // 使用者選擇匯入
    //--------------------------------------------------

    await _importWords(
      firstImport: true,
    );

    //--------------------------------------------------
    // 完成
    //--------------------------------------------------

    if (!mounted) return;

    setState(() {
      _isCheckingImport = false;
    });
  }
}
