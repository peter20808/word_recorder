import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {

  final String language;
  final String source;
  final String word;

  const StatusBar({

    super.key,

    required this.language,
    required this.source,
    required this.word,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(8),

      color: Colors.blueGrey.shade100,

      child: Row(

        children: [

          Expanded(
            child: Text("語言 : $language"),
          ),

          Expanded(
            child: Text("來源 : $source"),
          ),

          Expanded(
            child: Text("單字 : $word"),
          ),

        ],

      ),

    );

  }

}