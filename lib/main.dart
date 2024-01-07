import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const ParckApp());
}

class ParckApp extends StatelessWidget {
  const ParckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}
