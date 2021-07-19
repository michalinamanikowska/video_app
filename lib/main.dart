import 'package:flutter/material.dart';
import 'screens/overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        backgroundColor: Colors.grey[800],
        accentColor: Colors.cyan,
        fontFamily: 'MyFont',
      ),
      home: OverviewScreen(),
    );
  }
}
