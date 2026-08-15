import 'package:flutter/material.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';

///======================================================
/// 標題 + TextField
///======================================================
///
/// 使用方式：
///
/// LabeledTextField(
///   title: "Word",
///   hintText: "請輸入單字",
///   controller: _wordController,
/// )
///
class LabeledTextField extends StatelessWidget {
  final String title;

  final String hintText;

  final TextEditingController controller;

  final int maxLines;

  final ValueChanged<String>? onChanged;

  final TextInputType keyboardType;

  const LabeledTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.card,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            title,
            style: AppTextStyle.label,
          ),

          const SizedBox(height: 8),

          TextField(
            controller: controller,

            keyboardType: keyboardType,

            maxLines: maxLines,

            onChanged: onChanged,

            decoration: InputDecoration(
              hintText: hintText,

              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}