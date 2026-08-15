import 'package:flutter/material.dart';

import '../model/word.dart';


class SimilarWordList extends StatelessWidget {
  final List<Word> words;

  const SimilarWordList({
    super.key,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    if(words.isEmpty){
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "已有相似單字",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          ...words.map(
            (word)=>Card(
              child: ListTile(

                title: Text(
                  word.word,
                ),

                subtitle: Text(
                  word.meaning,
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}