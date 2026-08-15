import 'package:flutter/material.dart';

import '../data/word_database.dart';
import '../model/word.dart';

import '../widgets/detail_section.dart';

import 'add_word_page.dart';

class WordDetailPage extends StatefulWidget {

  final Word word;

  const WordDetailPage({
    super.key,
    required this.word,
  });

  @override
  State<WordDetailPage> createState() =>
      _WordDetailPageState();

}

class _WordDetailPageState
    extends State<WordDetailPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("單字詳細資料"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.word.meaning,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: OutlinedButton.icon(
                onPressed: _toggleFavorite,
                icon: Icon(
                  widget.word.favorite
                      ? Icons.star
                      : Icons.star_border,
                ),
                label: Text(
                  widget.word.favorite
                      ? "已收藏"
                      : "加入收藏",
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 20),

            //-------------------------------------

            DetailSection(
              title: "Language",
              value: widget.word.language,
            ),

            //-------------------------------------
            DetailSection(
              title: "Source",
              value: widget.word.source,
            ),

            DetailSection(
              title: "Category",
              value: widget.word.category,
            ),

            //-------------------------------------
            DetailSection(
              title: "Note",
              value: widget.word.note,
            ),

            DetailSection(
              title: "建立時間",
              value: _formatDateTime(
                widget.word.createTime,
              ),
            ),

            //--------------------------------------

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                  onPressed: _editWord,
                  child: const Text("修改"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(

                    onPressed: () {
                      _showDeleteDialog();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("刪除"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("刪除單字"),
          content: Text(
            "確定要刪除「${widget.word.word}」嗎？",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("取消"),
            ),

            ElevatedButton(
              onPressed: _deleteWord,//無參數的寫法
              child: const Text("刪除"),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _deleteWord() async {
    await WordDatabase.removeWord(
      widget.word,
    );

    Navigator.pop(context);

    Navigator.pop(
      context,
      true,
    );
  }

  void _toggleFavorite() {
    setState(() {
      widget.word.favorite = !widget.word.favorite;
    });

    WordDatabase.updateWord(
      widget.word,
      widget.word,
    );
  }

  Future<void> _editWord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddWordPage(
          word: widget.word,
        ),
      ),
    );

    if (result == true) {
      setState(() {});
      Navigator.pop(
        context,
        true,
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }
}