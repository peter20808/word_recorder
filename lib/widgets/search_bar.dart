import 'package:flutter/material.dart';

class WordSearchBar extends StatelessWidget {

  final TextEditingController controller;
  
  final ValueChanged<String>? onChanged;

  final String hintText;

  const WordSearchBar({
    super.key,
    required this.controller,
    this.hintText = "搜尋單字、翻譯或備註...",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      onChanged: onChanged,

      decoration: InputDecoration(

        hintText: hintText,

        prefixIcon: const Icon(Icons.search),

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(10),

        ),

      ),

    );

  }

}