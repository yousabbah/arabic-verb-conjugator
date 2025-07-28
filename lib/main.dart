import 'package:flutter/material.dart';
import 'package:arabic_verb_final/screens/conjugation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic Verb Conjugator',
      home: const ConjugationScreen(),
    );
  }
}