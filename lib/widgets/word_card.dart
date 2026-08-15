import 'package:flutter/material.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';
import '../model/word.dart';

///======================================================
/// 單字卡片
///======================================================
///
/// 用於：
///
/// • 所有單字
/// • 搜尋結果
/// • 收藏
/// • 今日複習
///
class WordCard extends StatelessWidget {
  final Word word;

  final VoidCallback? onTap;

  final VoidCallback? onFavoriteChanged;
  
  final VoidCallback? onDelete;

  const WordCard({
    super.key,
    required this.word,
    this.onTap,
    this.onFavoriteChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: word.favorite
        ? const Color.fromARGB(240, 144, 233, 236)
        : const Color.fromARGB(255, 250, 249, 249),
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppSpacing.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //--------------------------------------------------
              // Word
              //--------------------------------------------------

              Row(
                children: [
                  Expanded(
                    child: Text(
                      word.word,
                      style: AppTextStyle.word,
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      word.favorite
                          ? Icons.star
                          : Icons.star_border,
                    size: 22,
                    color: word.favorite
                        ? Colors.amber
                        : Colors.grey,
                    ),
                    onPressed: onFavoriteChanged,
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    onPressed: onDelete,
                  )
                ],
              ),

              const SizedBox(height: 8),

              //--------------------------------------------------
              // Meaning
              //--------------------------------------------------

              Text(
                word.meaning,

                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              //--------------------------------------------------
              // Language + Source
              //--------------------------------------------------

              Row(
                children: [

                  Icon(
                    Icons.language,
                    size: 18,
                    color: Colors.grey[700],
                  ),

                  const SizedBox(width: 4),

                  Text(
                    word.language,
                  ),

                  const Spacer(),

                  Icon(
                    Icons.menu_book,
                    size: 18,
                    color: Colors.grey[700],
                  ),

                  const SizedBox(width: 4),

                  Flexible(
                    child: Text(
                      word.source.isEmpty
                          ? "-"
                          : word.source,

                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}