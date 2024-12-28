import 'package:chat_assistant_ai/home_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_assistant_ai/pallete.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ('allen assistant'),
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        )
      ),
      home: HomePage()
    );
  }
}
