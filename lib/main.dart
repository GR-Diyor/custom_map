import 'package:custom_map/core/config/app_screen_style.dart';
import 'package:custom_map/feature/presentation/page/home.dart';
import 'package:flutter/material.dart';

void main() {
  AppStyle.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom map',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
