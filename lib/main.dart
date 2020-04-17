import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/anasyafa.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelimeleri Hatırla',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

