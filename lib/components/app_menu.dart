import 'package:flutter/material.dart';

enum AppMenuItem {
  home,
  addWord,
  allWords,
}

class AppMenu extends StatelessWidget {
  final void Function(AppMenuItem item) onSelected;

  const AppMenu({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppMenuItem>(
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: AppMenuItem.home,
          child: Text('首頁'),
        ),
        PopupMenuItem(
          value: AppMenuItem.addWord,
          child: Text('新增單字'),
        ),
        PopupMenuItem(
          value: AppMenuItem.allWords,
          child: Text('全部單字'),
        ),
      ],
    );
  }
}