import 'package:flutter/material.dart';
import 'package:flutter_animation/pages/flip_card_animation.dart';
import 'package:flutter_animation/pages/wheel_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: WheelAnimation(),
    );
  }
}

