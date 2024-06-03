import 'package:flutter/material.dart';
import 'package:todo_stream/widgets/lista.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista Steams',
      home: Lista(),
    );
  }
}
