import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/overview_screen.dart';
import 'repositories/videos_repository.dart';
import 'bloc/videos_bloc.dart';

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
        home: BlocProvider(
          create: (context) => VideosBloc(VideosRepository()),
          child: OverviewScreen(),
        ));
  }
}
