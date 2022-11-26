import 'package:drivaar/Screen/splash/splash.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primarySwatch: app_color_full,

          ),
      home: const Splash(),
    );
  }
}
