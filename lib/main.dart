import 'package:flutter/material.dart';

import 'menu_screen.dart';

void main() {
  runApp(const MyApp());
}

final themeData = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 91, 25, 204)),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 25))),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 25),
      titleLarge: TextStyle(fontSize: 35),
      titleMedium: TextStyle(fontSize: 25)),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DDemo',
      theme: themeData,
      home: const MenuScreen(),
    );
  }
}
