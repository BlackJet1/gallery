import 'package:flutter/material.dart';
import 'package:gal_test/screen/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
          key: _key,
          body: MainScreen(
            scKey: _key,
          )),
    );
  }
}
