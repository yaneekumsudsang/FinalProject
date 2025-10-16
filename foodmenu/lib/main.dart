import 'package:flutter/material.dart';
import 'views/home_template.dart';
import 'views/menu_list_view.dart';

void main() {
  runApp(const FoodMenuApp());
}

class FoodMenuApp extends StatelessWidget {
  const FoodMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodMenu+ 🍱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        fontFamily: 'sans-serif',
      ),
      home: const HomeTemplate(),
      routes: {
        '/menu-list': (context) => const MenuListView(),
      },
    );
  }
}