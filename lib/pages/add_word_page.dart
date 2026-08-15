import 'package:flutter/material.dart';

import '../model/word.dart';
import '../data/word_database.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/labeled_dropdown.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_bar.dart';
import '../widgets/similar_word_list.dart';

import '../constants/ui_constants.dart';

import 'home_page.dart';
import 'all_words_page.dart';
import '../components/app_menu.dart';
/// ===============================================
/// 新增單字頁面
/// ===============================================
class AddWordPage extends StatefulWidget {
  final Word? word;

  const AddWordPage({
    super.key,
    this.word,
  });
  
  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  bool get isEditMode => widget.word != null;
  List<Word> similarWords = [];
  //====================================================
  // TextField Controller
  //====================================================

  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  //====================================================
  // Language Dropdown
  //====================================================

  final List<String> _languageList = [
    "English",
    "Japanese",
    "Chinese",
    "Korean",
    "Other",
  ];

  final List<String> _categoryList = [
    "一般",
    "稱呼",
    "階級",
    "文法",
    "片語",
    "例句",
    "慣用語",
    "其他",
  ];

  String _selectedLanguage = "English";
  String _selectedCategory = "一般";

  //====================================================
  // 離開畫面時釋放 Controller
  //====================================================

  @override
  void dispose() {
    _sourceController.dispose();
    _wordController.dispose();
    _meaningController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.word != null) {
      _selectedLanguage =
          widget.word!.language;

      _sourceController.text =
          widget.word!.source;

      _selectedCategory =
          widget.word!.category;

      _wordController.text =
          widget.word!.word;

      _meaningController.text =
          widget.word!.meaning;

      _noteController.text =
          widget.word!.note;
    }
  }

  //====================================================
  // UI
  //====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(isEditMode ? "修改單字" : "新增單字",),
        centerTitle: true,
          actions: [
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

      // 鍵盤跳出時畫面仍可捲動
      body: SingleChildScrollView(
        padding: UIConstants.pagePadding,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Status Bar--------------------------------------------------

            StatusBar(
              language: _selectedLanguage,
              source: _sourceController.text,
              word: _wordController.text,
            ),

            const SizedBox(
              height: UIConstants.spacing,
            ),

          // Language--------------------------------------------------

          LabeledDropdown(
            title: "語言",
            value: _selectedLanguage,
            items: _languageList,
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _selectedLanguage = value;
              });
            },
          ),

          //--------------------------------------------------
          // Source
          //--------------------------------------------------

          LabeledTextField(
            title: "單字來源",
            hintText: "例如：漫畫、小說、動畫...",
            controller: _sourceController,
            onChanged: (value) {
              setState(() {});
            },
          ),

          //--------------------------------------------------
          // Category
          //--------------------------------------------------

          LabeledDropdown(
            title: "類別",
            value: _selectedCategory,
            items: _categoryList,
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _selectedCategory = value;
              });
            },
          ),

          //--------------------------------------------------
          // Word
          //--------------------------------------------------

          LabeledTextField(
            title: "單字",
            hintText: "請輸入單字",
            controller: _wordController,
            onChanged: _checkSimilarWords,
          ),

          SimilarWordList(
            words: similarWords,
          ),

          //--------------------------------------------------
          // Meaning
          //--------------------------------------------------

          LabeledTextField(
            title: "翻譯意思",
            hintText: "請輸入中文意思",
            controller: _meaningController,
          ),

          //--------------------------------------------------
          // Note
          //--------------------------------------------------

          LabeledTextField(
            title: "備註",
            hintText: "備註...",
            controller: _noteController,
            maxLines: 4,
          ),

          //--------------------------------------------------
          // Save Button
          //--------------------------------------------------

          PrimaryButton(
            text: isEditMode ? "更新" : "紀錄",
            onPressed: _saveWord,
          ),
          ],
        ),
        ),
      );
  }

  Future<void> _saveWord() async {
    //--------------------------------------------------
    // 必填欄位檢查
    //--------------------------------------------------

    if (_wordController.text.trim().isEmpty) {
      _showMessage("請輸入單字");
      return;
    }

    if (_meaningController.text.trim().isEmpty) {
      _showMessage("請輸入中文意思");
      return;
    }

    //--------------------------------------------------
    // 建立 Word
    //--------------------------------------------------

    Word word = Word(
      language: _selectedLanguage,
      source: _sourceController.text.trim(),
      category: _selectedCategory,
      word: _wordController.text.trim(),
      meaning: _meaningController.text.trim(),
      note: _noteController.text.trim(),
      favorite: isEditMode
        ? widget.word!.favorite
        : false,
    );

    //--------------------------------------------------
    // 加入 / 更新 Database
    //--------------------------------------------------

    if (isEditMode) {
      await _updateWord(word);

      _showMessage("更新成功");

      Navigator.pop(
        context,
        true,
      );
    } else {
      await _addWord(word);

      _showMessage("新增成功");
    }

    //--------------------------------------------------
    // 清空輸入
    //--------------------------------------------------

    _clearInput();
  }

  Future<void> _addWord(
    Word word,
  ) async {
    await WordDatabase.addWord(word);
  }

  Future<void> _updateWord(
    Word word,
  ) async {
    await WordDatabase.updateWord(
      widget.word!,
      word,
    );
  }

  void _clearInput() {
    //_sourceController.clear();
    _wordController.clear();
    _meaningController.clear();
    _noteController.clear();

    setState(() {
      // Language 保留
    });
  }

  void _checkSimilarWords(String value){

    if(value.trim().isEmpty){
      setState(() {
        similarWords = [];
      });
      return;
    }
    final keyword =
        value.toLowerCase();

    setState(() {
      similarWords =
          WordDatabase.words.where((word){
        return word.word
            .toLowerCase()
            .contains(keyword);
      }).toList();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}