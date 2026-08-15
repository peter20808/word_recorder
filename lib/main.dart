import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

import 'data/word_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WordDatabase.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Word Book",

      theme: AppTheme.light(),
      home: const HomePage(),
    );
  }
}