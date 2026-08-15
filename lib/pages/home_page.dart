import 'package:flutter/material.dart';

import 'add_word_page.dart';
import 'all_words_page.dart';

import '../components/app_menu.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("單字紀錄"),
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

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            ElevatedButton(

              child: const Text("紀錄單字"),

              onPressed: (){

                Navigator.push(

                  context,

                  MaterialPageRoute(
                    builder: (_) => const AddWordPage(),
                  ),

                );

              },
            ),
            
            const SizedBox(height:20),

            ElevatedButton(

              child: const Text("所有單字"),

              onPressed: (){

                Navigator.push(

                  context,

                  MaterialPageRoute(
                    builder: (_) => const AllWordsPage(),
                  ),

                );

              },

            ),
            

          ],

        ),

      ),

    );

  }

}